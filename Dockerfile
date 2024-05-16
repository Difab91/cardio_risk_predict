FROM python:3.10


WORKDIR /workspace


RUN apt-get update && apt-get install -y \
    r-base \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev

#  variables d'environnement pour rpy2
ENV R_HOME /usr/lib/R
ENV PATH $PATH:/usr/lib/R/bin


COPY requirements.txt .


RUN pip install --upgrade pip


RUN pip install -r requirements.txt


RUN pip install ipykernel -U --user --force-reinstall


COPY install.R .

# Exécuter le script d'installation des packages R
RUN Rscript install.R

# Copier les fichiers de l'application dans le répertoire de travail
COPY . .

# Exposer le port sur lequel l'application va tourner
EXPOSE 5000

# Définir le point d'entrée pour exécuter l'application Flask
CMD ["python", "app.py"]