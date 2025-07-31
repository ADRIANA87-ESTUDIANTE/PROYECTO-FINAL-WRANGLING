#### ACTIVIDAD 2

### CARGAR PAQUETES 
install.packages("readr")
install.packages("readxl")
install.packages("here")
install.packages("dplyr")
install.packages("janitor")

## CARGAR LIBRERIAS
library(readr)
library(readxl)
library(here)
library(dplyr)
library(janitor)
library(stringr)

##leer un archivo CSV

datos_csv <-read_csv(here("data","raw", "datos.csv.ejercicio.csv"), locale=locale(encoding = "Latin1"))

glimpse(datos_csv)

### cargar de datos desde la web

### lectura directa desde URL

datos_web <- read_csv("https://www.datos.gob.mx/dataset/fe305a2e-f0f5-43b6-9ced-8bdb486bf5ab/resource/ce6d882c-51bd-4ba4-bfcc-422b62af94f5/download/07_fortal_prog_fitozoosan_e_inocuidad_op_org_admon_riesgos_emerg_2024.csv")

### DESCARGA DE ARCHIVO

download.file("https://www.datos.gob.mx/dataset/fe305a2e-f0f5-43b6-9ced-8bdb486bf5ab/resource/ce6d882c-51bd-4ba4-bfcc-422b62af94f5/download/07_fortal_prog_fitozoosan_e_inocuidad_op_org_admon_riesgos_emerg_2024.csv",destfile = here("data","raw","datospag.csv"))

datos_descargados <-read_csv(here("data","raw","datospag.csv"))

###copiar archivo a processed antes de modificarlo
datos_originales <-read_csv(here("data","raw","datospag.csv"))

###auditoria

summary(datos_descargados)
head(datos_descargados)
str(datos_descargados)


###normalizar los datos

datos_descargados <-datos_descargados %>% clean_names()

##verificar  los nombres de las columnas despues de la limpieza
colnames(datos_descargados)

## estandarizarización

datos_descargados <-datos_descargados %>% mutate(actividad = str_to_lower(actividad))
datos_descargados <-datos_descargados %>% mutate(eslabon = str_to_lower(eslabon))

### remplazar valores
datos_descargados <-datos_descargados %>% mutate(estratificacion = str_replace_all(estratificacion, "MUY BAJO" , "1"))

### eliminar espacios en blancos

datos_descargados <-datos_descargados %>% mutate(beneficiario = str_trim(beneficiario), actividad = str_trim(actividad))

## conversion de TIPOS

datos_descargados <-datos_descargados %>% mutate(fecha=as.Date(fecha,format("%y-%m-%d")))

###numerico
datos_descargados <-datos_descargados %>% mutate(monto_federal=as.numeric(monto_federal))

datos_descargados <-datos_descargados %>% mutate(monto_federal=as.double(monto_federal))

str(datos_descargados)

##duplicados
datos_descargados <-datos_descargados[!duplicated(datos_descargados),]
sum(duplicated(datos_descargados))

###GUARDAR DATOS PROCESADOS
write.csv(datos_descargados,"data/processed/clean_data.csv",row.names = FALSE)


##DOCUMENTAR LA FUENTE DE DATOS
##ORIGEN: Plataforma Nacional de Datos Abiertos Mexico-SECRETARIA DE AGRICULTURA Y DESARROLLO RURAL (SADER)
### URL: "https://www.datos.gob.mx
## fecha descarga: 28/07/25
## Método de lectura: read_csv  ,codification UTF-8

##https://github.com/ADRIANA87-ESTUDIANTE/PROYECTO-FINAL-WRANGLING
