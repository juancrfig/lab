# Cargar librerías necesarias
library(magrittr)  # Para usar pipes
library(janitor)   # Para limpiar nombres de variables

# Importar la base de datos
data <- read.csv("cultivos.csv")

# a. Contextualización y dimensiones
# La base de datos contiene información sobre cultivos en departamentos y municipios de Colombia,
# como tipo de cultivo, área sembrada, producción y rendimiento.
num_filas <- data %>% nrow()
num_columnas <- data %>% ncol()
cat("La base de datos tiene", num_filas, "filas y", num_columnas, "columnas.\n")

# b. Encabezado y cola de los datos
# Mostrar primeras y últimas filas para verificar importación
# Estos dos comandos son parte de las buenas practicas. Nos permiten verificar 
# la correcta importación de los datos.

# Muestra las primeras seis filas del conjunto de datos.
data %>% head()
# Muestra las últimas seis filas del conjunto de datos.
data %>% tail()

# c. Limpieza de nombres y análisis de datos

# La función "clean_names()" del paquete "janitor" convierte todos los caracteres
# a minúscula, remueve caracteres especiales y reemplaza los espacios con "_".

# Limpiar nombres (ej. "Área Sembrada (ha)" -> "area_sembrada_ha")
data <- data %>% clean_names()

# Revisar categorías mal escritas (ejemplo: departamento y cultivo)
data %>% pull(departamento) %>% table()  # Muestra cantidad de apariciones por departamento
data %>% pull(cultivo) %>% table()       # Ver cantidad de apariciones por cultivo

# Analizar datos faltantes
# Esta linea de código muestra a detalle las entradas marcadas como NA
data %>% is.na() %>% colSums()  # Cantidad de NA por columna

# d. Descripción de variables y tipos en R
# - cod_dep: Código del departamento (categórica nominal)
# - departamento: Nombre del departamento (categórica nominal)
# - cod_mun: Código del municipio (categórica nominal)
# - municipio: Nombre del municipio (categórica nominal)
# - grupo_de_cultivo: Grupo del cultivo (categórica nominal)
# - subgrupo_de_cultivo: Subgrupo del cultivo (categórica nominal)
# - cultivo: Nombre del cultivo (categórica nominal)
# - desagregacion_regional_y_o_sistema_productivo: Detalle regional o sistema (categórica nominal)
# - ano: Año de registro (numérica discreta)
# - periodo: Periodo del año, ej. 2006B (categórica nominal)
# - area_sembrada_ha: Área sembrada en hectáreas (numérica continua)
# - area_cosechada_ha: Área cosechada en hectáreas (numérica continua)
# - produccion_t: Producción en toneladas (numérica continua)
# - rendimiento_t_ha: Rendimiento en toneladas por hectárea (numérica continua)
# - estado_fisico_produccion: Estado del producto, ej. fruto fresco (categórica nominal)
# - nombre_cientifico: Nombre científico del cultivo (categórica nominal)
# - ciclo_de_cultivo: Ciclo del cultivo, ej. transitorio (categórica nominal)

# Ver cómo R reconoce las variables
str(data)

# e. Análisis de variables
# Categóricas: tablas de frecuencias
data %>% pull(departamento) %>% table()         # Distribución por departamento
data %>% pull(grupo_de_cultivo) %>% table()     # Distribución por grupo de cultivo
data %>% pull(ciclo_de_cultivo) %>% table()     # Distribución por ciclo

# Numéricas: resúmenes y gráficas
data %>% select(area_sembrada_ha) %>% summary() # Resumen de área sembrada
# Histograma con foco en las 0-1000 hectareas
data %>% filter(area_sembrada_ha <= 1000) %>% pull(area_sembrada_ha) %>% hist(
  main = "Histograma de Área Sembrada",
  xlab = "Hectáreas",
  xlim = c(0, 1000),
  breaks = seq(0, 1000, by = 10)
)
data %>% select(produccion_t) %>% summary()     # Resumen de producción
# Boxplot con rango del eje y limitado.
data %>% pull(produccion_t) %>% boxplot(
  main = "Boxplot de Producción",
  ylab = "Toneladas",
  ylim = c(0, 2000)  # Foco en 0-2000 toneladas, para ver la mayoría de la data.
)
