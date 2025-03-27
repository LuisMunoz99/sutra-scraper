library(rvest)       # Para leer y parsear HTML
library(tidyverse)   # Para manipular datos (dplyr, purrr, stringr, tibble, readr)
library(glue)        # Para construir strings con variables incrustadas (interpolación)
library(here)        # Para rutas relativas robustas dentro del proyecto

get_url_medidas <- function(cuatrienio_id) {
  url <- glue("https://sutra.oslpr.org/medidas?cuatrienio_id={cuatrienio_id}")
  page <- read_html(url)
  links <- page %>%
    html_elements("a") %>%              # Encuentra todas las etiquetas <a>
    html_attr("href") %>%               # Extrae el atributo href de cada <a>
    str_subset("^/medidas/") %>%        # Filtra solo los que comienzan con "/medidas/"
    unique()                             # Elimina duplicados

  tibble(
    cuatrienio = cuatrienio_id,                                      # Cuatrienio actual (filtro)
    medida_url = paste0("https://sutra.oslpr.org", links),          # URL completa a la medida
    medida_id = str_extract(links, "\\d+$"),                        # Extrae el número al final del enlace
    medida_uid = paste0("Q", cuatrienio_id, "_", medida_id)        # ID único compuesto
  )
}

scrape_desc <- function(medida_url) {
  page <- read_html(medida_url)
  tibble(
    titulo = page %>%
      html_element("h1") %>%
      html_text(trim = TRUE),  # Extrae el <h1> y limpia espacios

    cuatrienio = page %>%
      html_elements("span") %>%
      html_text() %>%
      str_subset("Cuatrienio:") %>%
      str_remove("Cuatrienio:") %>%
      str_trim() %>%
      first(),

    fecha_radicacion = page %>%
      html_elements("span") %>%
      html_text() %>%
      str_subset("Fecha de Radicación:") %>%
      str_remove("Fecha de Radicación:") %>%
      str_trim() %>%
      first()
  )
}


medidas_urls <- get_url_medidas(2021) 

medidas_completas <- medidas_urls %>%
  mutate(description = map(medida_url, scrape_desc)) 


# output
saveRDS(medidas_completas, here("individual/scrape-sutra/desc/output", glue("meta_medidas_{cuatrienio_id}.rds")))

