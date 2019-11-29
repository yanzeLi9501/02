####  --   ---
library(xlsx);

list <- read.xlsx2(file = "list_all.xlsx", sheetIndex = 1, as.data.frame = T );

genus.cutoff = 0.4;
reads.min.count = 5;


library(dplyr);
library(reshape2);
library("ggplot2");

###############################################
##### species level analysis --#####################################################################################################
{
### -- use foreach package use 20 CPU --
	library("foreach");
	library("doParallel");

	cl<-makeCluster(10);
	registerDoParallel(cl)

		df <- foreach( x = 1:nrow(list), .combine = "rbind" )  %dopar% {

			label <- paste(as.character( list[x,3] ), as.character( list[x,1] ), sep = "-");
			print(x);
			print(label);

			human.mapseqfile <- paste("/mnt/raid1/liyanze/pair/1/04_mapseq", "/", as.character( list[x,3] ), sep = "");
			mouse.mapseqfile <- paste("/mnt/raid1/liyanze/pair/1/04_mapseq", "/", as.character( list[x,1] ), sep = "");

			if( file.exists( human.mapseqfile ) & file.exists( mouse.mapseqfile ) ){

				library(dplyr);
				library(reshape2);

				mouse <- read.delim(file = mouse.mapseqfile, sep = "\t", header = T, as.is = T, skip = 1);
				human <- read.delim(file = human.mapseqfile, sep = "\t", header = T, as.is = T, skip = 1);

## --- ??? score_cf >= 0.4 --
				mouse.good <- subset( mouse, score_cf.5 >= genus.cutoff & NCBI.Kingdom %in% c("Bacteria", "Archaea")  )[, c( "NCBI.Kingdom", "Phylum", "Class", "Order", "Family","Genus", "Species")];
				human.good <- subset( human, score_cf.5 >= genus.cutoff & NCBI.Kingdom %in% c("Bacteria", "Archaea")  )[, c( "NCBI.Kingdom", "Phylum", "Class", "Order", "Family","Genus", "Species")];

## -- species --
				mouse.species.stats <- mouse.good %>% group_by(Species) %>% summarise( count  = n()) %>% filter( count >= 2) %>% arrange( desc(count) );
				human.species.stats <- human.good %>% group_by(Species) %>% summarise( count  = n()) %>% filter( count >= 2) %>% arrange( desc(count) );

## -- calculate percentage --
				mouse.species.stats[, "pct"] <- mouse.species.stats[, "count"] / sum(mouse.species.stats[, "count"]) * 100;
				human.species.stats[, "pct"] <- human.species.stats[, "count"] / sum(human.species.stats[, "count"]) * 100;

## -- merge ---
				dat <- rbind( data.frame( human.species.stats, cat = "human"),
						data.frame( mouse.species.stats, cat = "mouse"));

## -- dcat --
				dat2  <- dcast( dat[, c("Species", "cat", "pct")], Species ~ cat, value.var = "pct", fill = 0 ) %>% arrange( desc(human)  );
				dat2[, "pair"] <- label;

## -- return --
				return(dat2);
			}else {
				print("file not exists ");
			}
		}

	stopCluster(cl);

#### ---- plot -----
	df[, "m2h"] <- as.numeric( df[, "mouse"] ) - as.numeric( df[, "human"] );

	sig <- df %>% group_by(Species) %>% summarise( md = median( m2h ) ) %>% arrange( desc(md) ) %>% filter( md >=2 | md <= -1);

	df.sel <- subset(df, df$Species %in% sig$Species);

	ggplot( df.sel , aes( reorder( df.sel$Species, m2h, median), m2h )) + geom_boxplot() + 
		theme(axis.text.x = element_text(angle = 90, hjust = 1));



## -- reduced --
	abundance_cutoff <- 0.1;
	df.reduced <- subset( df, as.numeric( human ) >= abundance_cutoff & as.numeric( mouse ) >= abundance_cutoff );
	df.reduced[, "reduced_pct"] <- log2( as.numeric( df.reduced[, "mouse"]  ) / as.numeric( df.reduced[, "human"] ) );

	samples.count <- table( df.reduced$Species );

	df.reduced[, "sample_count"] <- as.numeric( samples.count[ as.character( df.reduced[,  "Species"]) ] );
        
        #list<-read.csv("/mnt/raid1/liyanze/all/Genus-Species.csv",header=TRUE)
        #df.reduced<-merge(df.reduced,list,by="Species",all=FALSE)

        #g<-read.csv("OverTwoSpecies.csv",header=TRUE)
        #df.reduced<-merge(df.reduced,g,by="Genus",all=FALSE)
	g<-read.csv("Species_foldChange_position.csv",header=TRUE)
	g<-g[g$condition=="decrease",]  #####################---------  condition can be changed
        
	df.reduced<-merge(df.reduced,g,by="Species",all=FALSE)
        
#####################################################-----------------  plot Decrease Species ---------------#######################################
	plot1 <-
		ggplot( df.reduced , aes(x= reorder( df.reduced$Species, reduced_pct, median), y=reduced_pct  )) + 
		geom_boxplot(aes(fill=sample_count) ) + 
	        #geom_dotplot(binaxis="y",stackdir="center",binwidth=0.2,stackgroups=TRUE,binposition="all")+
	        theme_classic() +
	        theme( panel.grid.major = element_line() )+  
		theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
		scale_fill_gradient(low="#132B43",high="#56B1F7",limits=c(100,1600)) +
                #facet_wrap(~ Genus,scales="free_x")+
		geom_hline(yintercept = c(1,-1), colour = "darkred", linetype = 2)+
                theme(axis.text.x = element_blank())+
                #scale_fill_discrete(guide = FALSE)+                       
                guides(fill=guide_legend(title="Sample Count"))+
		coord_flip()+
                labs( y='Log2 ( fold change )',x='Species',title="Decrease");
        #write.csv(df.reduced,"Species_reduced.csv")
	ggsave("SpeciesChangeBoxPlot_Decrease.pdf", plot1,width = 7, height =5 ,limitsize = FALSE);
       
}

###############################################
##### Genus level analysis --
{
### -- use foreach package use 20CPU --
	library("foreach");
	library("doParallel");
#stopCluster(cl);
	cl<-makeCluster(10);
	registerDoParallel(cl)

		df.genus <- foreach( x = 1:nrow(list), .combine = "rbind" )  %dopar% {

			label <- paste(as.character( list[x,3] ), as.character( list[x,1] ), sep = "-");
			print(x);
			print(label);

			human.mapseqfile <- paste("/mnt/raid1/liyanze/pair/1/04_mapseq", "/", as.character( list[x,3] ), sep = "");
			mouse.mapseqfile <- paste("/mnt/raid1/liyanze/pair/1/04_mapseq", "/", as.character( list[x,1] ), sep = "");

			if( file.exists( human.mapseqfile ) & file.exists( mouse.mapseqfile ) ){

				library(dplyr);
				library(reshape2);

				mouse <- read.delim(file = mouse.mapseqfile, sep = "\t", header = T, as.is = T, skip = 1);
				human <- read.delim(file = human.mapseqfile, sep = "\t", header = T, as.is = T, skip = 1);

## --- ??? score_cf >= 0.4 --
				mouse.good <- subset( mouse, score_cf.5 >= genus.cutoff & NCBI.Kingdom %in% c("Bacteria", "Archaea")  )[, c( "NCBI.Kingdom", "Phylum", "Class", "Order", "Family","Genus", "Species")];
				human.good <- subset( human, score_cf.5 >= genus.cutoff & NCBI.Kingdom %in% c("Bacteria", "Archaea")  )[, c( "NCBI.Kingdom", "Phylum", "Class", "Order", "Family","Genus", "Species")];

## -- ??? GENUS levels --
				mouse.genus.stats <- mouse.good %>% group_by(Genus) %>% summarise( count  = n()) %>% filter( count >= 2) %>% arrange( desc(count) );
				human.genus.stats <- human.good %>% group_by(Genus) %>% summarise( count  = n()) %>% filter( count >= 2) %>% arrange( desc(count) );

## -- calculate percentage --
				mouse.genus.stats[, "pct"] <- mouse.genus.stats[, "count"] / sum(mouse.genus.stats[, "count"]) * 100;
				human.genus.stats[, "pct"] <- human.genus.stats[, "count"] / sum(human.genus.stats[, "count"]) * 100;

## -- merge ---
				dat <- rbind( data.frame( human.genus.stats, cat = "human"),
						data.frame( mouse.genus.stats, cat = "mouse"));

## -- dcat, --
				dat2  <- dcast( dat[, c("Genus", "cat", "pct")], Genus ~ cat, value.var = "pct", fill = 0 ) %>% arrange( desc(human)  );
				dat2[, "pair"] <- label;

## -- return --
				return(dat2);
			}else {
				print("file not exists ");
			}
		}
	stopCluster(cl);

## -- reduced --
	abundance_cutoff <- 0.1;
	df.genus.reduced <- subset( df.genus, as.numeric( human ) >= abundance_cutoff & as.numeric( mouse ) >= abundance_cutoff );
	df.genus.reduced[, "reduced_pct"] <- log2( as.numeric( df.genus.reduced[, "mouse"]  ) / as.numeric( df.genus.reduced[, "human"] ) );

	samples.count <- table( df.genus.reduced$Genus );

	df.genus.reduced[, "sample_count"] <- as.numeric( samples.count[ as.character( df.genus.reduced[,  "Genus"]) ] );
	
	a<-read.csv("Genus_foldChange_condition.csv",header=TRUE)
	a<-a[a$condition=="decrease",]   #################################------  condition can be changed
        
	df.genus.reduced<-merge(df.genus.reduced,a,by="Genus",all=FALSE)
###################--------------------------------  plot Genus  -----------------#################################
	plot1.genus <-
		ggplot( df.genus.reduced , aes(x= reorder( df.genus.reduced$Genus, reduced_pct, median),y= reduced_pct)) + 
		geom_boxplot(aes(fill=sample_count) ) + 
	        #geom_dotplot(binaxis="y",stackdir="center",binwidth=0.2,stackgroups=TRUE,binposition="all")+
	        theme_classic() +
	        theme( panel.grid.major = element_line() )+
		theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
		scale_fill_gradient(low="#132B43",high="#56B1F7",limits=c(100,1600)) +
		geom_hline(yintercept = c(1,-1), colour = "darkred", linetype = 2)+
                guides(fill=guide_legend(title="Sample Count"))+
                coord_flip()+
		labs( y='Log2(fold change)',x='Genus')
	#write.csv(df.genus.reduced,"Genus_reduced.csv")
	ggsave("GenusChangeBoxPlot_Decrease.pdf", plot1.genus,width = 7, height = 3);
        
}



#############################################################
####### ------------ without cut off analysis ---------###############
### -- iterate the list, read a pair of mapseq results  --
{

	df <- do.call( rbind,
			lapply( 1:nrow(list), function(x) {

				label <- paste(as.character( list[x,3] ), as.character( list[x,1] ), sep = "-");
				print(x);
				print(label);

				human.mapseqfile <- paste("/mnt/raid1/liyanze/pair/1/04_mapseq", "/", as.character( list[x,3] ), sep = "");
				mouse.mapseqfile <- paste("/mnt/raid1/liyanze/pair/1/04_mapseq", "/", as.character( list[x,1] ), sep = "");

				if( !file.exists( human.mapseqfile ) | !file.exists( mouse.mapseqfile ) ){
				print("file not exists ");
				return();
				}

				mouse <- read.delim(file = mouse.mapseqfile, sep = "\t", header = T, as.is = T, skip = 1);
				human <- read.delim(file = human.mapseqfile, sep = "\t", header = T, as.is = T, skip = 1);

## --- ??? score_cf >= 0.4 --
				mouse.good <- subset( mouse, score_cf.5 >= genus.cutoff & NCBI.Kingdom %in% c("Bacteria", "Archaea")  )[, c( "NCBI.Kingdom", "Phylum", "Class", "Order", "Family","Genus", "Species")];
				human.good <- subset( human, score_cf.5 >= genus.cutoff & NCBI.Kingdom %in% c("Bacteria", "Archaea")  )[, c( "NCBI.Kingdom", "Phylum", "Class", "Order", "Family","Genus", "Species")];

## --  species  --
				mouse.species.stats <- mouse.good %>% group_by(Species) %>% summarise( count  = n()) %>% filter( count >= 2) %>% arrange( desc(count) );
				human.species.stats <- human.good %>% group_by(Species) %>% summarise( count  = n()) %>% filter( count >= 2) %>% arrange( desc(count) );

## -- calculate percentage --
				mouse.species.stats[, "pct"] <- mouse.species.stats[, "count"] / sum(mouse.species.stats[, "count"]) * 100;
				human.species.stats[, "pct"] <- human.species.stats[, "count"] / sum(human.species.stats[, "count"]) * 100;

## -- merge ---
				dat <- rbind( data.frame( human.species.stats, cat = "human"),
						data.frame( mouse.species.stats, cat = "mouse"));

## -- dcat --
				dat2  <- dcast( dat[, c("Species", "cat", "pct")], Species ~ cat, value.var = "pct", fill = 0 ) %>% arrange( desc(human)  );
				dat2[, "pair"] <- label;

## -- return --
				return(dat2);

			}) );

	df[, "m2h"] <- df[, "mouse"] - df[, "human"];
	ggplot(df, aes( reorder( df$Species, m2h, median), m2h )) + geom_boxplot() + 
		theme(axis.text.x = element_text(angle = 90, hjust = 1));
####write.csv(df,"df_no_cut_off0.1.csv")
################################
####
	ggplot(df)  + geom_point( aes( x = human, y = mouse)) + scale_x_log10() + scale_y_log10();
	cor.test(df$human, df$mouse );





}
