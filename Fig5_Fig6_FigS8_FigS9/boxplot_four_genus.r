rbind<-read.csv("highchange_ratio2.csv",header=TRUE)
rbind<-rbind[,-1]
#human<-rbind[rbind$fed=="humanfood",]
#mouse<-rbind[rbind$fed=="mousefood",]

table<-aggregate(rbind[,-c(1:5)],list(rbind$condition,rbind$Genus),median)
human<-table[,c(1,2,3)]
mouse<-table[,c(1,2,4)]
human$type<-"human"
mouse$type<-"mouse"
names(human)<-c("condition","Genus","ratio","type")
names(mouse)<-c("condition","Genus","ratio","type")
allbind<-rbind(mouse,human)
Bac<-allbind[allbind$Genus=="Bacteroides",]
Bif<-allbind[allbind$Genus=="Bifidobacterium",]
Rum<-allbind[allbind$Genus=="Ruminococcus",]
Pre<-allbind[allbind$Genus=="Prevotella",]
rbindFour<-rbind(Bif,Rum,Pre,Bac)

library(ggplot2)
library(ggthemes)
#ggplot( allbind ) + geom_boxplot( aes(type, ratio,fill=type ) );  
#g<-ggplot( rbindFour ) + geom_boxplot( aes(Genus, ratio,fill=type ) )+
g<-ggplot(transform(rbindFour,Genus=factor(Genus,levels=c("Bifidobacterium","Ruminococcus","Prevotella","Bacteroides"))))+
  geom_boxplot( aes(Genus, ratio,fill=type ) )+
  facet_wrap(~ Genus, scales="free",ncol = 4)+
  theme(strip.text.x = element_text(size=0))+
  theme_classic() +
  theme( panel.grid.major = element_line() )+
  scale_y_continuous(name = "relative abundance (%)" ) 

ggsave("boxplotFourgenus.pdf", g,width=7,height = 5)

