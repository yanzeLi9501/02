humanGenus<-read.csv("Genus_log2Human.csv",header =TRUE)
colnames(humanGenus)<-c("number","Genus","foldChangehuman")
mouseGenus<-read.csv("Genus_log2Mouse.csv",header=TRUE)
allGenus<-read.csv("Genus_foldChangeAll.csv",header=TRUE)

humanSpecies<-read.csv("Species_log2Human.csv",header=TRUE)
colnames(humanSpecies)<-c("number","Species","foldChangehuman")
mouseSpecies<-read.csv("Species_log2Mouse.csv",header=TRUE)
allSpecies<-read.csv("Species_foldChangeAll.csv",header=TRUE)

GenusComm<-merge(humanGenus,mouseGenus,by="Genus",all=FALSE)
GenusComm<-merge(GenusComm,allGenus,by="Genus",all=FALSE)
SpeciesComm<-merge(humanSpecies,mouseSpecies,by="Species",all=FALSE)
SpeciesComm<-merge(SpeciesComm,allSpecies,by="Species",all=FALSE)
library(ggplot2)
#g<-ggplot(GenusComm,aes(foldChangemouse,foldChangehuman))+
#  geom_point(aes(col=condition))+
#  #geom_smooth(method="lm",se=FALSE,size=.5,col="darkblue")+
#  geom_abline(slope=1)+
#  theme_classic() +
#  theme( panel.grid.major = element_line() )+  
#  scale_color_brewer(palette = "Dark2")+
#  #theme_minimal()+
#  labs( y='log2FC,controlled diet',x='log2FC,non-controlled diet',title="Genus")

#ggsave("GenusDot.pdf", g,width = 5, height =4 ,limitsize = FALSE)

j<-ggplot(GenusComm,aes(x=foldChangemouse,y=foldChangehuman))+
  geom_point(aes(col=condition,))+
  #geom_smooth(method="lm",se=FALSE,size=.5,col="darkblue")+
  geom_abline(slope=1)+
  theme_classic() +
  theme( panel.grid.major = element_line() )+  
  geom_hline(yintercept = c(1,-1),colour = "darkred", linetype = 2)+
  geom_vline(xintercept = c(1,-1),colour = "darkred", linetype = 2)+
  scale_color_brewer(palette = "Dark2")+
  #theme_minimal()+
  labs( y='log2FC,controlled diet',x='log2FC,non-controlled diet',title="Genus")

ggsave("GenusDot.pdf", j,width = 5, height =4 ,limitsize = FALSE)
