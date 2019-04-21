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
  
  if (!is.installed("SnowballC")){
    install.packages("SnowballC")
  }
  
  if (!is.installed("wordcloud")){
    install.packages("wordcloud")
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

  if (!is.installed("XML")){
    install.packages("XML")
  }
  
  # llamamos las librerias necesarias
  library(tm)
  library(SnowballC)
  library(wordcloud)
  library(ggplot2)
  library(dplyr)
  library(readr)
  library(cluster)
  library(XML)
}

getTags <- function(tags){
  cont <- 1
  tagList <- list(xmlValue(tags[[1]]))

  while(cont <= length(tags)){
    tagList[[1]][cont] <- xmlValue(tags[[cont]])
    cont <- cont + 1
  }
  return(tagList)
}

getData <- function(file){
  articlesXML = xmlParse(file, encoding = "Spanish")
  articlesRoot = xmlRoot(articlesXML)
  articlesList = xmlChildren(articlesRoot)
  cont <- 1
  # obtengo todos los datos necesarios de cada articulo
  while(cont <= 4){
    article <- articlesList[[cont]]
    date <- xmlGetAttr(article, name = 'date')
    childrenArticle <- xmlChildren(article)
    title <- xmlValue(childrenArticle[[1]])
    tags <- xmlChildren(childrenArticle[[2]])
    tagList <- getTags(tags)
    text <- xmlValue(childrenArticle[[3]])
    
    cont <- cont + 1
  }
  
}

main <- function(){
  installLibraries()
  
  file <- "./data/elpais1970.xml"
  getData(file)
  
  
  
}

main()