import rpy2.robjects as ro
from rpy2.rinterface_lib.embedded import RRuntimeError
import pandas as pd
from rpy2.robjects import pandas2ri


pandas2ri.activate()
class modele_cardio_risk():
    def __init__(self):
        self.appliquer_modele = None

    def charger_modele(self, chemin ):
        try:
            # Charger le script R
            ro.r.source(chemin)

            # Accéder à la fonction appliquer_modele depuis l'environnement global
            self.appliquer_modele = ro.globalenv['appliquer_modele']
            print("Modèle sélectionné chargé avec succès.")
        except RRuntimeError as e:
            print("Erreur lors du chargement du fichier R:", e)


    def predire(self, nouvelles_donnees):
        if self.appliquer_modele is None:
            raise Exception("Le modèle n'a pas été chargé.")
        r_dataframe = pandas2ri.py2rpy(nouvelles_donnees)
        return self.appliquer_modele(r_dataframe)

#nouvelles_donnees = pd.DataFrame({'age': [58], 'education': [3],'sex': [0], 'is_smoking': [0],'cigsPerDay': [31], 'BPMeds': [1],'prevalentStroke': [0], 'prevalentHyp': [1],'diabetes': [1], 'totChol': [201],'sysBP': [255.0], 'diaBP': [120.0],'BMI': [24.21], 'heartRate': [89],'glucose': [101], 'TenYearCHD': [0]})
#nouvelles_donnees['sex'] = pd.Categorical(nouvelles_donnees['sex'], categories=[0, 1], ordered=False)
#print(nouvelles_donnees)

#modele_cardio_risk = modele_cardio_risk()


#modele_cardio_risk.charger_modele("app_modele.R")

#resultat = modele_cardio_risk.predire(nouvelles_donnees)

#print(resultat)