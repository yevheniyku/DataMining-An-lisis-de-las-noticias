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
  
  # llamamos las librerias necesarias
  library(rvest)
  library(rlist)
  library(httr)
  library(jsonlite)
}

##################################################################
# La funcion que recorre los articulos de El Pais 
##################################################################
iterateArticles <- function(startDate, endDate, urlElPais){
  # recorremos todas las fechas   
  while(startDate <= endDate){
    #date <- as.Date(start, format="%d-%m-%Y")
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
    }
    
    for(i in length(listUrl)){
      if(startDate == endDate){
        last <- length(listUrl)
        lenLast <- length(listUrl[[last]])
        lastArticle <- listUrl[[last]][lenLast]
        lapply(listUrl[[i]], function(x) accessArticle(x, x == lastArticle))
      }
      else {
        lapply(listUrl[[i]], function(x) accessArticle(x, FALSE))
      }
    }
    #incrementamos la fecha 
    startDate <- startDate + 1
  }
}

accessArticle <- function(url, lastDay){
  url <- gsub("//", "https://", url, fixed = TRUE)
  
  newSession <- html_session(url)
  page  <- jump_to(newSession, url)  %>% read_html()
  
  title <- html_node(page, '.articulo-titulo')      %>% html_text
  date  <- html_node(page, '.articulo-actualizado') %>% html_attr('datetime')
  text  <- html_node(page, '.articulo-cuerpo')      %>% html_text()
  tag   <- c(html_node(page, '.listado') %>% html_nodes('li') %>% html_node('a') %>% html_text)
  
  data <- list(title = title, date = date, tags = list(tag), text = text)
  
  print(date)
  
  jsonData <- toJSON(data, pretty = TRUE, auto_unbox = TRUE)
  
  if(!lastDay){
    jsonData <- paste0(jsonData, ',')
  }
  
  write(jsonData, file = "data/elpais.json", append = TRUE)
}

main <- function(){
  installLibraries()
  
  # guardamos la url base de el Pais
  urlElPais <- 'https://elpais.com/tag/fecha/'
  # guardamos y le damos formato a la fecha inicio del webscrapping 
  startDate <- as.Date("04-05-1976", format="%d-%m-%Y")
  start <- format(startDate, format="%d-%m-%Y")
  # guardamos y le damos formato a la ultima fecha de webscrapping 
  # que corresponde al dia de hoy
  #endDate <- as.Date("05-05-1976", format="%d-%m-%Y")
  endDate <- Sys.Date()
  # crea un directoryo donde se va a guardar el csv
  dir.create("data/", showWarnings = FALSE)
  write('[', file = "data/elpais.json")
  
  iterateArticles(startDate, endDate, urlElPais)
  
  write(']', file = "data/elpais.json", append = TRUE)
}

main()
