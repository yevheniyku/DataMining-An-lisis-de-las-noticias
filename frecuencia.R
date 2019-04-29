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
  
  if (!is.installed("ngram")){
    install.packages("ngram")
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
  library(ngram)
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

##################################################################
# Limpiamos el conjunto de noticias
##################################################################

cleanText <- function(text){
  
  #Caracteres especiales fuera
  text <- gsub("[[:cntrl:]]", " ", text)
  #Convertimos a minusculas
  text <- tolower(text)
  #Eliminación de palabras vacias (con poco valor)
  text <- removeWords(text, words = stopwords("spanish"))
  #Eliminamos la puntuación
  text <- removePunctuation(text)
  #Eliminamos los numeros
  text <- removeNumbers(text)
  #Eliminamos espacios vacios excesivos
  text <- stripWhitespace(text)
  #Eliminamos las tildes
  text <- chartr('?????','aeiou',text)
  
  text <- removeWords(text, words = c("usted", "pues", "tal","articulo", "tan", "asi", "dijo", "como", 
                                      "sino", "entonces", "aunque", "don", "doña", "este", "en",
                                      "impresa", "edicion"))
  
  text <- removeWords(text, words = c("lunes","martes","miercoles","jueves","viernes","sabado"
                                      ,"domingo"))
  
  
  
  return (text)
  
}

##################################################################
# Frecuencia de uso de las palabras y asociaciones
##################################################################
Wordsfrec <- function(corpus,year){
  
  nov_tdm <- TermDocumentMatrix(corpus)
  nov_mat <- as.matrix(nov_tdm)
  dim(nov_mat)
  
  nov_mat <- nov_mat %>% rowSums() %>% sort(decreasing = TRUE)
  nov_mat <- data.frame(palabra = names(nov_mat), frec = nov_mat)
  
  print(nov_mat[1:20,])
  
  
   path <- paste0('./img/Frec',year,'.png')
   nov_mat[1:20, ] %>%
     ggplot(aes(palabra, frec)) +
     geom_bar(stat = "identity", color = "black", fill = "#87CEFA") +
     geom_text(aes(hjust = 1.3, label = frec)) +
     coord_flip() +
     labs(title = "Diez palabras mas frecuentes",  x = "Palabras", y = "Numero de usos")
   
  ggsave(path)
  
  findAssocs(nov_tdm, terms = c("malos"), corlimit = .25)

  #Eliminar términos dispersos
  nov_new <- removeSparseTerms(nov_tdm, sparse = .95)
  nov_new <- nov_new %>% as.matrix()
  nov_new <- nov_new / rowSums(nov_new)
  nov_dist <- dist(nov_new, method = "euclidian")
 
  nov_hclust <-  hclust(nov_dist, method = "ward.D")
  
  path <- paste0('./img/FHclust',year,'.png')
  png(path, width = 2500, height = 2000)
  plot(nov_hclust, main = "Dendrograma - hclust", sub = "", xlab = "")
    

  dev.off()
}



#################################################################
#Nube de palabras más frecuentes de la década
#################################################################
wordsCloud <- function(text,corpus,year){
  
  

  path <- paste0('./img/cloud',year,'.png')

  png(path)
  dibujo <- wordcloud(corpus, max.words = 80, random.order = F, colors = brewer.pal(name = "Dark2", n = 8))
  dev.off()

}

##################################################################
# Estudio de las noticias (nube, frecuencia,Asociaciones)
##################################################################

totalNewsanalysis <- function(allTexts,year){
  
  #limpiamos todas las noticias
  allTexts <- cleanText(allTexts)
  #Creamos el corpus
  corpus <- Corpus(VectorSource(allTexts))
  #Sacamos la nuve de frecuencia
  wordsCloud(allTexts,corpus,year)
  #Gráfico de las diez palabras más usadas
  Wordsfrec(corpus,year)

}

clean <- function(text){
  cText <- NULL
  cont <- 1
  
  while(cont < length(text[[1]])){
    if(text[[1]][cont] != ""){
      part <- text[[1]][cont]
      cText <- c(cText, part)
    }
    cont <- cont + 1
  } 
  return(toString(cText))
}

##################################################################
# Obtiene todos los textos de las noticias y los une para poder
# analizar luego la frecuencia de palabras.
##################################################################
getData <- function(file,year){
  allTexts <- NULL
  allTags <- NULL
  articlesXML = xmlParse(file, encoding = "UTF-8")
  articlesRoot = xmlRoot(articlesXML)
  articlesList = xmlChildren(articlesRoot)
  cont <- 1
  # obtengo todos los datos necesarios de cada articulo
  while(cont <= 2000){#length(articlesList)
    article <- articlesList[[cont]]
    date <- xmlGetAttr(article, name = 'date')
    childrenArticle <- xmlChildren(article)
    title <- xmlValue(childrenArticle[[1]])
    # tags <- xmlChildren(childrenArticle[[2]])
    # tagList <- getTags(tags)
    text <- xmlValue(childrenArticle[[3]])
    textSplit <- strsplit(text, '\n')
    cText <- clean(textSplit)
  
    if(is.null(allTexts))
      allTexts <- combine(text)
    else
      allTexts <- combine(allTexts, cText)
    
    cont <- cont + 1
  }
  
  totalNewsanalysis(allTexts,year)
  
}

main <- function(){
  installLibraries()
  
  file <- "./data/elpais1970.xml"
  
  getData(file,"1970")
  
  # file <- "./data/elpais1980.xml"
  # getData(file,"1980")
  # 
  # file <- "./data/elpais1990.xml"
  # getData(file,"1990")
 
  
}

main()
