#################################################################
# Este script sirve para obtener todos los articulos del archivo 
# del periodico el Pais, desde el año 1976 y hasta hoy.
#################################################################


# funcion para ver si el paquete ya está instalado
is.installed <- function(mypkg) {
  is.element(mypkg, installed.packages()[,1]) 
}

# instalamos el paquete rvest en caso de que no esté instalado
if (!is.installed("rvest")){
  install.packages("rvest")
}

library(rvest)

# guardamos la url base de el Pais
urlElPais <- 'https://elpais.com/tag/fecha/'
# guardamos y le damos formato a la fecha inicio del webscrapping 
startDate <- as.Date("04-05-1976", format="%d-%m-%Y")
start <- format(startDate, format="%d-%m-%Y")

# guardamos y le damos formato a la ultima fecha de webscrapping 
# que corresponde al dia de hoy
endDate <- Sys.Date()
endDate <- format(endDate, format="%d-%m-%Y")

# recorremos todas las fechas   
while(start <= endDate){
  
  date <- as.Date(start, format="%d-%m-%Y")
  urlDate <- format(date, format="%Y%m%d")
  # generamos la url con la fecha
  final <- paste0(urlElPais, urlDate)
  
  # hacemos la peticion
  page <- read_html(final)
  
  # guardamos los titulos de todos los articulos 
  allTitles <- html_nodes(page, '.articulo-titulo')
  print(allTitles)
  
  while (length(html_nodes(page, '.paginacion-siguiente')) != 0){
    # sacamos la url de la siguiente pagina
    nextPage  <- html_nodes(page, '.paginacion-siguiente') %>% html_nodes('a') %>% html_attr('href')
    
    page <- jump_to(nextPage) %>% read_html()
    
    allTitles <- html_nodes(page, '.articulo-titulo')
    print(allTitles)
    class(allTitles)
  }
  
  # de cada titulo sacamos los enlaces 
  links <- allTitles %>% html_nodes('a') %>% html_attr('href')

  
  #incrementamos la fecha 
  start <- start+1
}
