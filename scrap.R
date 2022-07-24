library("tidyverse")

liste_ministres <- "https://www.gouvernement.fr/composition-du-gouvernement" %>%
  GET() %>%
  content() %>%
  html_nodes(css = ".ministre-nom")

tibble(
  ministre  = liste_ministres %>% html_text(), 
  slug = liste_ministres %>% html_attr(name = "href")
  ) %>% 
  write_csv(path = "liste_ministres.csv")

get_collaborateurs <- function(slug) {
  page_ministre <- paste0(
    "https://www.gouvernement.fr/", 
    slug, 
    "#rf-accordion-group-colab-0") %>%
    GET() %>%
    content()
  tibble(
    slug = slug, 
    collaborateur_nom = page_ministre %>%  
      html_nodes(css = ".rf-b_minister-colab") %>%
      html_nodes(css = ".rf-b_minister-colab-title") %>%
      html_text(), 
    collaborateur_fonction =  page_ministre %>% 
      html_nodes(css = ".rf-b_minister-colab") %>%
      html_nodes(css = ".rf-b_minister-colab-fonction") %>%
      html_text(), 
    collaborateur_jo = page_ministre %>%
    html_nodes(css = ".rf-b_minister-colab") %>%
    html_nodes(css = ".rf-b_minister-colab-jo") %>%
      html_text()
    )
}
get_collaborateurs(slug = "ministre/elisabeth-borne")

liste_ministres %>%
  html_attr(name = "href") %>%
  map_df(.f = get_collaborateurs) %>%
  write_csv(path = "liste_collaborateurs.csv")

