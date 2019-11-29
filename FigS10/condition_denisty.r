condition1<-read.csv("Condition_enterotype_runID_fix.csv",header=TRUE)
condition1<-condition1[c(2,3,4,5,6,7)]
condition2<-read.csv("list_condition_complex.csv",header=TRUE)
condition2<-condition2[c(1,2,3)]

condition3<-merge(condition2,condition1,by="mouse",all=TRUE)

write.csv(condition3,"Condition3.csv")


condition1$count<-1
c1<-aggregate(condition1$count,list(condition1$condition,condition1$fed),sum)
colnames(c1)<-c("condition","ExperimentalCondition","count")
dens2<-ggplot(c1, aes(x=count,color=ExperimentalCondition))+
  scale_color_brewer(palette="Dark2") + 
  theme_minimal()+
  theme( panel.grid.major = element_line() )+
  geom_density()+
  labs( y='Density',x='Number of Human-mouse Pairs')

ggsave("condition_density.pdf", dens2,width = 8, height = 5) 
