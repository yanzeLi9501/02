
############################################################################################---  plot all genus' change in different conditions  -----########################################################

allGenus<-read.csv("Species_reducedAll_Percent.csv",header=TRUE)
changelist<-read.table("SpeciesChangelist.txt",header=TRUE,sep="\t")
w<-merge(changelist,allGenus,all=FALSE)
condition.change<-read.csv("condition_change_moreCondition.csv",header=TRUE)
w2<-merge(condition.change,w,by="mouse",all=FALSE)
#write.csv(w2,"species_df_h233.csv")

rbind<-read.csv("species_df_h233.csv",header=TRUE)
rbind<-rbind[rbind$humanPer>0,]
#rbind<-rbind[,-1]
human<-rbind[rbind$fed=="humanfood",]
mouse<-rbind[rbind$fed=="mousefood",]

table1<-aggregate(human$humanPer,list(human$condition,human$Species),median)
table2<-aggregate(mouse$mousePer,list(mouse$condition,mouse$Species),median)
colnames(table1)<-c("condition","Species","ratio")
colnames(table2)<-c("condition","Species","ratio")
#human<-table[,c(1,2,3)]
#mouse<-table[,c(1,2,4)]
table1$type<-"human"
table2$type<-"mouse"
#names(human)<-c("condition","Genus","ratio","type")
#names(mouse)<-c("condition","Genus","ratio","type")
allbind<-rbind(table2,table1)


library(ggplot2)
library(ggthemes)
#ggplot( allbind ) + geom_boxplot( aes(type, ratio,fill=type ) );  
g<-ggplot( allbind ) + geom_boxplot( aes(Species, ratio,fill=type ) )+
  facet_wrap(~ Species, scales="free",ncol=5)+
  theme(strip.text.x = element_text(size=0))+
  theme_bw() +
  theme( panel.grid.major = element_line() )+  
  scale_y_continuous(name = "relative abundance (%)" )

ggsave("boxplotAllSpecies.pdf", g,width=10,height = 25)

