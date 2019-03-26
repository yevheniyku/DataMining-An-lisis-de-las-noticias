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


frecuenceAnali<- function(){
  
  
  
  nov_raw <- read_lines("data/elpais.txt", skip = 419, n_max = 8313-419)
  
  
  
}
