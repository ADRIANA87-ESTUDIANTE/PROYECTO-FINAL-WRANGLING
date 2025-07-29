#### ACTIVIDAD 1

### CARGAR PAQUETES 
install.packages("readr")
install.packages("readxl")
install.packages("here")
install.packages("dplyr")

## CARGAR LIBRERIAS
library(readr)
library(readxl)
library(here)
library(dplyr)


##leer un archivo CSV

datos_csv <-read_csv(here("data","raw", "datos.csv.ejercicio.csv"), locale=locale(encoding = "Latin1"))

glimpse(datos_csv)


### cargar de datos desde la web

datos_web <- read_csv("https://www.datos.gob.mx/dataset/fe305a2e-f0f5-43b6-9ced-8bdb486bf5ab/resource/ce6d882c-51bd-4ba4-bfcc-422b62af94f5/download/07_fortal_prog_fitozoosan_e_inocuidad_op_org_admon_riesgos_emerg_2024.csv")


##DOCUMENTAR LA FUENTE DE DATOS
##ORIGEN: Plataforma Nacional de Datos Abiertos Mexico-SECRETARIA DE AGRICULTURA Y DESARROLLO RURAL (SADER)
### URL: "https://www.datos.gob.mx
## fecha descarga: 28/07/25
## Método de lectura: read_csv , delimtador "," ,codification UTF-8
