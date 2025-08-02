#### ACTIVIDAD 2

### CARGAR PAQUETES 
install.packages("readr")
install.packages("readxl")
install.packages("here")
install.packages("dplyr")
install.packages("janitor")
install.packages("tidyr")

## CARGAR LIBRERIAS
library(readr)
library(readxl)
library(here)
library(dplyr)
library(janitor)
library(stringr)
library(lubridate)
library(tidyr)

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
datos_descargados <-datos_descargados %>% mutate(ciclo_agricola = str_replace_all(ciclo_agricola, "0" , "primavera"))


### eliminar espacios en blancos

datos_descargados <-datos_descargados %>% mutate(beneficiario = str_trim(beneficiario), actividad = str_trim(actividad))

## conversion de TIPOS

datos_descargados <-datos_descargados %>% mutate(fecha=as.Date(fecha,format("%D-%M-%Y")))

###numerico
datos_descargados <-datos_descargados %>% mutate(monto_federal=as.numeric(monto_federal))

datos_descargados <-datos_descargados %>% mutate(monto_federal=as.double(monto_federal))

datos_descargados <-datos_descargados %>% mutate(monto_federal=as.character(monto_federal))

str(datos_descargados)

##duplicados
datos_descargados <-datos_descargados[!duplicated(datos_descargados),]
sum(duplicated(datos_descargados))

###GUARDAR DATOS PROCESADOS
write.csv(datos_descargados,"data/processed/clean_data.csv",row.names = FALSE)

### Aplicar Pivot_longer

datos_largos <- datos_descargados %>%
  pivot_longer(
    cols = c(monto_federal, apoyo, actividad, eslabon, ciclo_agricola),
    names_to = "tipo_dato",
    values_to = "valor"
  )

##agrupara por tipo datos y totales

datos_largos %>%
  filter(tipo_dato == "monto_federal") %>%
  mutate(valor = as.numeric(valor)) %>%
  group_by(entidad) %>%
  summarise(total_apoyo = sum(valor, na.rm = TRUE)) %>%
  arrange(desc(total_apoyo))

###datos separados
datos_separados <- datos_descargados %>%
  separate(apoyo, into = c("tipo_apoyo_1", "tipo_apoyo_2"), sep = " ", extra = "merge", fill = "right")

total_apoyos <-data_frame(entidad = c("BAJA CALIFORNIA","BAJA CALIFORNIA SUR","SAN LUIS POTOSI","YUCATAN","GUERRERO", "EDO MEXICO","CAMPECHE", "COLIMA","TABASCO","QUINTANA ROO", "OAXACA","MORELOS","VERACRUZ","NAYARIT","SONORA"), 
  total = c("15400000", "1200000","11600000","900000","800000","630000","6000000","5000000","5000000","4800000","4399750","2500000","1500000","1000000","1000000")
)

## datos combinados
datos_combinados <- datos_separados %>%
  mutate(entidad = str_to_upper(str_trim(entidad))) %>%
  left_join(
    total_apoyos %>%
      mutate(entidad = str_to_upper(str_trim(entidad)), total = as.numeric(total)),
    by = "entidad"
  )


datos_separados <-datos_separados %>% mutate(mes=str_trim(mes))


write.csv(datos_largos,"data/processed/clean_datafinal.csv",row.names = FALSE)



##DOCUMENTAR LA FUENTE DE DATOS
##ORIGEN: Plataforma Nacional de Datos Abiertos Mexico-SECRETARIA DE AGRICULTURA Y DESARROLLO RURAL (SADER)
### URL: "https://www.datos.gob.mx
## fecha descarga: 28/07/25
## Método de lectura: read_csv  ,codification UTF-8

##https://github.com/ADRIANA87-ESTUDIANTE/PROYECTO-FINAL-WRANGLING/blob/main/actvividad%202.R
