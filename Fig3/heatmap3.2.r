#!/bin/r
library(heatmap3);

x <- read.table("mdian_list.csv", sep=",");   ###########---  median value of all conditions  ----#####
y <- sapply(x[-1,-1], function(x) as.numeric(as.character(x)));
colnames(y) <- sapply(x[1,-1], as.character);
rownames(y) <- sapply(x[-1,1], as.character);

a <- read.table("x", sep="\t");
aa <- matrix(sapply(a[2,], function(x) as.numeric(as.character(x))), 1,);
colnames(aa) <- sapply(a[1,], as.character);
aa <- aa[,colnames(y)];

b <- read.table("y");
bb <- matrix(sapply(b[,2], function(x) as.numeric(as.character(x)) -1), , 1);
rownames(bb) <- sapply(b[,1], as.character);
bb <- bb[rownames(y),];

hc <- hclust(dist(y));
dd.col <- as.dendrogram(hc);
groups  <-  cutree(hc,k=6);
groups <- as.matrix(groups);


source("frac_rgb.r");   ########-----  colour palette
source("frac_light.r");
#rowside_ <- cbind(rep("white", nrow(x)- 1), frac_light(bb));
rowside_ <- matrix( frac_light(bb),ncol=1);
colnames(rowside_) <- 1;
colside_ <- rbind(frac_rgb(aa, colorRampPalette(c('white', 'chartreuse4'))(1000)));
rownames(colside_) <- 1;
pdf("heatmap3.pdf")
heatmap3(
		y,
		scale='colum',
		distfun=dist,
	  cexCol=0.9,		
		xlab = "Genus", 
		ylab = "Condotion",
		ColAxisColors = 0,
		RowAxisColors = 0,
	  #showRowDendro = TRUE,
		method="ward.D2",
		hclustfun = hclust,
		
		keep.dendro = TRUE,
    ColSideWidth = 1.2,
		ColSideLabs = "Rate of Change",
		RowSideLabs = "ExperimentalCondition",
		#ColSideCut=3,
		#RowSideCut=1,
		RowSideColors=rowside_,
		ColSideColors=t(colside_),
		margin=c(16,19),
		balanceColor=TRUE,
		
		);
dev.off()
