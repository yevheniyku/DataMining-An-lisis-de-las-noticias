##################################################################
##
## Este script sirve para obtener todos los articulos del archivo 
## del periodico el Pais, desde el año 1976 y hasta hoy.
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
  if (!is.installed("rvest")){
    install.packages("rvest")
  }
  
  if (!is.installed("rlist")){
    install.packages("rlist")
  }
  
  if (!is.installed("httr")){
    install.packages("httr")
  }
  
  if (!is.installed("jsonlite")){
    install.packages("jsonlite")
  }
  
  if (!is.installed("XML")){
    install.packages("XML")
  }
  
  if (!is.installed("numbers")){
    install.packages("numbers")
  }
  # llamamos las librerias necesarias
  library(numbers)
  library(rvest)
  library(rlist)
  library(httr)
  library(jsonlite)
  library(XML)
}

getYear <- function(date){
  dateSplit <- strsplit(toString(date), "[-]")
  return(unlist(dateSplit)[1])
}

writeXML <- function(xmlFile, actual, endDate){
  if(actual == endDate){
    year <- as.numeric(getYear(endDate + 1))
    decade <- toString(year - 10) 
    ext <- paste0(decade, ".xml")
    print(ext)
    file <- paste0("data/elpais", ext)
    saveXML(xmlFile, file = file, indent = TRUE, encoding = "Spanish")
  }
}

accessArticle <- function(url, root, date){
  url <- gsub("//", "https://", url, fixed = TRUE)

  newSession <- html_session(url)
  page  <- jump_to(newSession, url)  %>% read_html()
  
  title <- html_node(page, '.articulo-titulo') %>% html_text
  text  <- html_node(page, '.articulo-cuerpo') %>% html_text()
  tag   <- html_node(page, '.listado') %>% html_nodes('li') %>% html_node('a') %>% html_text
  
  articleXML <- newXMLNode("article", parent = root, attrs = c(date = date))
  newXMLNode("title", title, parent = articleXML)
  tagList <- newXMLNode("tags", parent = articleXML)
  lapply(tag, function(x) {
    newXMLNode("tag", x, parent = tagList)
  })
  newXMLNode("text", text, parent = articleXML)
  
}

getUrlList <- function(startDate, endDate, urlElPais){
  urlDate <- format(startDate, format="%Y%m%d")
  # generamos la url con la fecha
  finalUrl <- paste0(urlElPais, urlDate)
  
  # comprobamos que la pagina existe y que no redirecciona
  # ni se genera ningun error
  if(http_status(GET(finalUrl))[[1]] == "Success"){
    
    # hacemos la peticion
    page <- read_html(finalUrl)
    session <- html_session(finalUrl)
    # guardamos los titulos de todos los articulos 
    listUrl <- list(html_nodes(page, '.articulo-titulo') %>% html_nodes('a') %>% html_attr('href'))
    
    # miramos si existe la clase de "paginacion-siguiente"
    # para ver si hay mas titulos. si la longitud es 0, es que 
    # solo hay una pagina con articulos ese dia 
    while (length(html_nodes(page, '.paginacion-siguiente')) != 0){
      # sacamos la url de la siguiente pagina
      nextPage  <- html_nodes(page, '.paginacion-siguiente') %>% html_nodes('a') %>% html_attr('href')
      # cargamos la siguiente pagina 
      page <- jump_to(session, nextPage) %>% read_html()
      # sacamos los articulos de la nueva pagina y los guardamos en 
      # la lista listUrl
      listUrl <- c(listUrl, list(html_nodes(page, '.articulo-titulo') %>% html_nodes('a') %>% html_attr('href')))
    }
    
    return(listUrl) 
  }
}

##################################################################
# La funcion que recorre los articulos de El Pais 
##################################################################
getArticles <- function(startDate, endDate){
  # creamos la raiz del xml
  root <- newXMLNode("articles")
  urlElPais <- 'https://elpais.com/tag/fecha/'
  
  # recorremos todas las fechas   
  while(startDate <= endDate){
    listUrl <- getUrlList(startDate, endDate, urlElPais)
    
    for(i in length(listUrl)){
        lapply(listUrl[[i]], function(x) accessArticle(x, root, startDate))
    }
    print(startDate)
    writeXML(root, startDate, endDate)
    #pasamos al siguiente dia 
    startDate <- startDate + 1
  }
}

managePeriods <- function(){
  #startDate <- as.Date("04-05-1976", format = "%d-%m-%Y")
  startDate <- as.Date("29-12-1979", format = "%d-%m-%Y")
  endDate   <- as.Date("31-12-1979", format = "%d-%m-%Y")
  getArticles(startDate, endDate)
  #startDate <- as.Date("01-01-1980", format = "%d-%m-%Y")
  startDate <- as.Date("29-12-1989", format = "%d-%m-%Y")
  endDate   <- as.Date("31-12-1989", format = "%d-%m-%Y")
  getArticles(startDate, endDate)
  startDate <- as.Date("01-01-1990", format = "%d-%m-%Y")
  endDate   <- as.Date("31-12-1999", format = "%d-%m-%Y")
  getArticles(startDate, endDate)
  startDate <- as.Date("01-01-2000", format = "%d-%m-%Y")
  endDate   <- as.Date("31-12-2009", format = "%d-%m-%Y")
  getArticles(startDate, endDate)
  startDate <- as.Date("01-01-2010", format = "%d-%m-%Y")
  endDate   <- as.Date("31-12-1979", format = "%d-%m-%Y")
  getArticles(startDate, endDate)

}

main <- function(){
  installLibraries()
  
  # crea un directoryo donde se va a guardar el csv
  dir.create("data/", showWarnings = FALSE)
  
  managePeriods()
}

main()
