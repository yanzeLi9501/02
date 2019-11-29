#BT<-read.table("TimeLine6Point.txt",header=T,sep="\t")
pairTimeline<-read.csv("pairTimeLine_Genus.csv")
pairTimeline$count<-1
humanfood<-pairTimeline[pairTimeline$fed=="humanfood",]
mousefood<-pairTimeline[pairTimeline$fed=="mousefood",]
humanE1<-humanfood[humanfood$hcluster==1,]
humanE2<-humanfood[humanfood$hcluster==2,]
humanE3<-humanfood[humanfood$hcluster==3,]

mouseE1<-mousefood[mousefood$hcluster==1,]
mouseE2<-mousefood[mousefood$hcluster==2,]
mouseE3<-mousefood[mousefood$hcluster==3,]

humanE3_6<-humanE3[humanE3$TimeDays<=6,]
humanE3_12<-humanE3[humanE3$TimeDays<=12,]
humanE3_18<-humanE3[humanE3$TimeDays<=18,]
humanE3_28<-humanE3[humanE3$TimeDays<=28,]
humanE3_38<-humanE3[humanE3$TimeDays<=38,]
humanE3_48<-humanE3[humanE3$TimeDays<=48,]

sum(humanE3_6$mcluster==3)/sum(humanE3_6$hcluster==3)
sum(humanE3_12$mcluster==3)/sum(humanE3_12$hcluster==3)
sum(humanE3_18$mcluster==3)/sum(humanE3_18$hcluster==3)
sum(humanE3_28$mcluster==3)/sum(humanE3_28$hcluster==3)
sum(humanE3_38$mcluster==3)/sum(humanE3_38$hcluster==3)
sum(mouseE3_48$mcluster==3)/sum(mouseE3_48$hcluster==3)



####################-----  divide into 6 points  ---------################
    

    
BT<-read.csv("TimeLine6SplitEnterotype.csv")
library(ggplot2)
 # turn-off scientific notation like 1e+48
human<-BT[c(1:6),]
mouse<-BT[c(7:12),]
gg<-ggplot(data=BT,aes(x=days,y=changeratio,group=enterotype,colour=enterotype))+
  theme(axis.text.x = element_text(angle=90, vjust=0.6)) +
  theme_classic() +
  theme( panel.grid.major = element_line() )+
  geom_line()+
  geom_point()+
  facet_wrap(~ type)+
  expand_limits(y=0)
  
  

  
  ggsave("BarplotTimeEnterotype3Type.pdf", gg,width = 8, height = 4)
  
