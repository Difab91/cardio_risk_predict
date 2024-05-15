appliquer_modele <- function(nouvelles_donnees) {
    modele <- readRDS("modele_selectionne.rds")
    previsions <- predict(modele, nouvelles_donnees, type = "response")
    return(previsions)
}