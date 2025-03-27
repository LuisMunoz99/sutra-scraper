# Cargar librerías necesarias
library(rvest)
library(tidyverse)

# URL base donde están las medidas
base_url <- "https://sutra.oslpr.org/medidas"

# Leer el contenido HTML de la página principal
page <- read_html(base_url)

# -----------------------------------
# 1. Extraer todos los enlaces de las medidas
# -----------------------------------

# Aquí buscamos todos los enlaces (<a>) con la clase 'measure-link' (suponiendo que esta clase esté presente en el HTML)
medida_links <- page %>%
  html_elements("a") %>%   # Busca todas las etiquetas <a>
  html_attr("href") %>%
  str_subset("^/medidas/")  # Filtramos enlaces que contienen '/medidas/'

medida_urls <- paste0("https://sutra.oslpr.org", medida_links)

medidas_df <- tibble(medida_url = medida_urls)


# Iterar sobre cada enlace en el dataframe y extraer información
medidas_df <- medidas_df %>%
  mutate(
    # Leer el contenido HTML de cada página de medida
    titulo = map(medida_url, ~{
      medida_page <- read_html(.x)  # Leer el HTML de la medida
      titulo <- medida_page %>%
        html_elements("h1") %>%    # Buscamos el título en <h1>
        html_text(trim = TRUE)     # Extraemos el texto limpio
      return(titulo)
    }),

    # Extraer el cuatrienio
    cuatrienio = map(medida_url, ~{
      medida_page <- read_html(.x)
      cuatrienio <- medida_page %>%
        html_elements("span") %>%       # Buscar todos los <span>
        html_text() %>%                
        str_subset("Cuatrienio:") %>%   # Filtrar por "Cuatrienio:"
        str_remove("Cuatrienio:") %>%   # Limpiar el texto
        str_trim()                      # Eliminar espacios extra
      return(cuatrienio)
    }),

    # Extraer la fecha de radicación
    fecha_radicacion = map(medida_url, ~{
      medida_page <- read_html(.x)
      fecha <- medida_page %>%
        html_elements("span") %>%       # Buscar todos los <span>
        html_text() %>%                
        str_subset("Fecha de Radicación:") %>%  # Filtrar por "Fecha de Radicación:"
        str_remove("Fecha de Radicación:") %>%  # Limpiar el texto
        str_trim()                      # Eliminar espacios extra
      return(fecha)
    })
  )

# Mostrar el dataframe con la información extraída
print(medidas_df)

