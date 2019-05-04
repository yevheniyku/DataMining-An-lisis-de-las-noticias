importLibraries <- function(){
  library(tm)
  library(SnowballC)
  library(wordcloud)
  library(ggplot2)
  library(dplyr)
  library(readr)
  library(cluster)
  library(ngram)
}

createWordCloud <- function(d, year){
  set.seed(1234)
  path <- paste0('./img/cloud',year,'.png')
  
  png(path)
  dibujo <-wordcloud(words = d$Word, freq = d$Freq, min.freq = 1, max.words=100, random.order=FALSE, rot.per=0.35, colors=brewer.pal(8, "Dark2"))
  dev.off()
}

mostFrequent <- function(d, year){
  path <- paste0('./img/Frec',year,'.png')
  
  d[1:20, ] %>%
    ggplot(aes(Word, Freq)) +
    geom_bar(stat = "identity", color = "black", fill = "#87CEFA") +
    geom_text(aes(hjust = 1.3, label = Freq)) +
    coord_flip() +
    labs(title = "Veinte palabras mas frecuentes",  x = "Palabras", y = "Numero de usos")
  
  ggsave(path)
}

main <- function(){
  importLibraries()
  
  file <- './data/1970.txt'
  df <- read.table(file, header = FALSE, col.names = c('Word', 'Freq'))
  
  createWordCloud(df, 1970)
  mostFrequent(df, 1970)
  
  
}

main()