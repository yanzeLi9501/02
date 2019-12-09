

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
  
