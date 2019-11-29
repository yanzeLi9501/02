rbind<-read.csv("highchange_ratio2_species.csv",header=TRUE)
rbind<-rbind[,-1]
#human<-rbind[rbind$fed=="humanfood",]
#mouse<-rbind[rbind$fed=="mousefood",]

table<-aggregate(rbind[,-c(1:4)],list(rbind$condition,rbind$Species),median)
human<-table[,c(1,2,3)]
mouse<-table[,c(1,2,4)]
human$type<-"human"
mouse$type<-"mouse"
names(human)<-c("condition","Species","ratio","type")
names(mouse)<-c("condition","Species","ratio","type")
allbind<-rbind(mouse,human)

Fae<-allbind[allbind$Species=="Faecalibacterium prausnitzii",]
Pre<-allbind[allbind$Species=="Prevotella copri",]
Akk<-allbind[allbind$Species=="Akkermansia muciniphila",]
Bac<-allbind[allbind$Species=="Bacteroides fragilis",]
rbindFour<-rbind(Fae,Pre,Bac,Akk)
library(ggplot2)
library(ggthemes)
#ggplot( allbind ) + geom_boxplot( aes(type, ratio,fill=type ) );  
#g<-ggplot(rbindFour ) + geom_boxplot( aes(Species, ratio,fill=type ) )+
g<-ggplot(transform(rbindFour,Species=factor(Species,levels=c("Faecalibacterium prausnitzii","Prevotella copri","Bacteroides fragilis","Akkermansia muciniphila"))))+
   geom_boxplot( aes(Species, ratio,fill=type ) )+
  facet_wrap(~ Species, scales="free",ncol = 4)+
  theme(strip.text.x = element_text(size=0))+
  theme_classic() +
  theme( panel.grid.major = element_line() )+
  scale_y_continuous(name = "relative abundance (%)" )

ggsave("boxplotfourSpecies.pdf", g,width=7,height = 5)

