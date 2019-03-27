##################################################################
##
## Este script sirve para realizar un análisis de frecuencias de 
## palabras de las noticias. Estas se dividirán por épocas
##
##################################################################

##################################################################
# funcion para ver si el paquete ya está instalado
##################################################################
is.installed <- function(mypkg) {
  is.element(mypkg, installed.packages()[,1]) 
}

##################################################################
# instalamos los paquetes en caso de que no esté instalado
##################################################################
installLibraries <- function(){
  if (!is.installed("tm")){
    install.packages("tm")
  }
  
  if (!is.installed("SnowBallC")){
    install.packages("SnowBallC")
  }
  
  if (!is.installed("worlcloud")){
    install.packages("worlcloud")
  }
  
  if (!is.installed("ggplot2")){
    install.packages("ggplot2")
  }
  
  if (!is.installed("dplyr")){
    install.packages("dplyr")
  }
  
  if (!is.installed("readr")){
    install.packages("readr")
  }
  
  if (!is.installed("cluster")){
    install.packages("cluster")
  }
  
  # llamamos las librerias necesarias
  library(tm)
  library(SnowballC)
  library(wordcloud)
  library(ggplot2)
  library(dplyr)
  library(readr)
  library(cluster)
}

openFile <- function(){
  return(file('data/elpais.txt', open = 'r'))
}


dataLooping<- function(){
  fd <- openFile()
  
  while(length(line <- readLines(fd, n = 1, warn = FALSE)) > 0){
    while(line != '------'){
      
    }
  }
  
}
