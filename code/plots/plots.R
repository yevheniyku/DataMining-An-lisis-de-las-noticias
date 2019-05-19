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
  dibujo <-wordcloud(words = d$Word, freq = d$Freq, min.freq = 1, max.words=30, random.order=FALSE, rot.per=0.35, colors=brewer.pal(8, "Dark2"))
  dev.off()
}

pieChart <- function(d, year){
  path <- paste0('./img/tag',year,'.png')
  d[1:10, ] %>%
    bp<- ggplot(aes(x="", y=Freq, fill=Tag))+
      geom_bar(width = 1, stat = "identity")
  
  pie <- bp + coord_polar("y", start=0)
  
  ggsave(path, pie)
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
  
  file <- './data/1980.txt'
  df <- read.table(file, header = FALSE, col.names = c('Word', 'Freq'))
  createWordCloud(df, 1980)
  mostFrequent(df, 1980)
  
  file <- './data/1990.txt'
  df <- read.table(file, header = FALSE, col.names = c('Word', 'Freq'))
  createWordCloud(df, 1990)
  mostFrequent(df, 1990)
  
  file <- './data/tets.txt'
  df <- read.table(file, sep = ";", header = FALSE, col.names = c('Word', 'Freq'), fileEncoding='utf-8', encoding='utf-8', strip.white = TRUE, quote = '"')
  print(df)
  mostFrequent(df, 'yoquese')
  
}

main()