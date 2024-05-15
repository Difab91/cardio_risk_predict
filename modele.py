import rpy2.robjects as ro

class modele_cardio_risk():
    def __init__(self):
        self.appliquer_modele = None

    def charger_modele(self, chemin):
        self.appliquer_modele = ro.r['appliquer_modele']
        ro.r['source'](chemin)


    def predire(self, nouvelles_donnees):
        if self.appliquer_modele is None:
            raise Exception("Le modèle n'a pas été chargé.")
        return self.appliquer_modele(nouvelles_donnees)
