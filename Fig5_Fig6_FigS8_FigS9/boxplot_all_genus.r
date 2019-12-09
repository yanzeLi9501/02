
rbind<-read.csv("genus_df_h233.csv",header=TRUE)
#rbind<-rbind[,-1]
human<-rbind[rbind$fed=="humanfood",]
mouse<-rbind[rbind$fed=="mousefood",]

table1<-aggregate(human$humanPer,list(human$condition,human$Genus),median)
table2<-aggregate(mouse$mousePer,list(mouse$condition,mouse$Genus),median)
colnames(table1)<-c("condition","Genus","ratio")
colnames(table2)<-c("condition","Genus","ratio")
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
g<-ggplot( allbind ) + geom_boxplot( aes(Genus, ratio,fill=type ) )+
  facet_wrap(~ Genus, scales="free",ncol=5)+
  theme(strip.text.x = element_text(size=0))+
  theme_bw() +
  theme( panel.grid.major = element_line() )+  
  scale_y_continuous(name = "relative abundance (%)" )

ggsave("boxplotAllGenus.pdf", g,width=10,height = 15)

