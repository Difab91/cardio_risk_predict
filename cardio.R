
# spécifier le libpaths de votre dossier contenant les packages (packages)

#.libPaths("packages")
.libPaths("R_packages")


library(knitr)
library(ggplot2)
library(cowplot)
library(corrplot)
library(plyr)

Data=read.csv("Data/data_cardiovascular_risk.csv", sep= "," , header= TRUE)


for (i in 7:10)
  Data[,i]<- factor(Data[,i])

Data$sex <- ifelse(Data$sex == "F", 1,0)

Data$is_smoking <- ifelse(Data$is_smoking == "YES", 1,0)

for (i in 3:5)
  Data[,i]<- factor(Data[,i])

Data[,17]<- factor(Data[,17])

Data[,1]<- str(Data[,1])

Data <- na.omit(Data)

head(Data)

summary(Data)

n <- nrow(Data)
n


train <- sample(1:n, 2*round(n /3))

data.train <- Data[ train, ]
data.test <- Data[-train, ]

# analyse univarié

summary(data.train)

apply(data.train,2,sd)

# analyse bivarié

summary(glm(TenYearCHD~age,data=data.train,family=binomial))

beta<-coef(glm(TenYearCHD~age,data=data.train,family=binomial))
x<-seq(0,100,by=0.01)
y<-exp(beta[1]+beta[2]*x)/(1+exp(beta[1]+beta[2]*x))
plot(x,y,type="l",xlab="age",ylab="p(x)")
abline(h=0.5,lty=2)
xlim<--beta[1]/beta[2]
abline(v=xlim,lty=2)

summary(glm(TenYearCHD~education,data=data.train,family=binomial))

summary(glm(TenYearCHD~sex,data=data.train,family=binomial))

summary(glm(TenYearCHD~is_smoking,data=Data,family=binomial))

summary(glm(TenYearCHD~cigsPerDay,data=data.train,family=binomial))

beta<-coef(glm(TenYearCHD~cigsPerDay,data=data.train,family=binomial))
x<-seq(0,200,by=0.01)
y<-exp(beta[1]+beta[2]*x)/(1+exp(beta[1]+beta[2]*x))
plot(x,y,type="l",xlab="nombre de cigarette par jour",ylab="p(x)")
abline(h=0.5,lty=2)
xlim<--beta[1]/beta[2]
abline(v=xlim,lty=2)

summary(glm(TenYearCHD~BPMeds,data=data.train,family=binomial))
summary(glm(TenYearCHD~prevalentStroke,data=data.train,family=binomial))
summary(glm(TenYearCHD~prevalentHyp,data=data.train,family=binomial))
summary(glm(TenYearCHD~diabetes,data=data.train,family=binomial))

summary(glm(TenYearCHD~totChol,data=data.train,family=binomial))


beta<-coef(glm(TenYearCHD~totChol,data=data.train,family=binomial))
x<-seq(150,700,by=0.01)
y<-exp(beta[1]+beta[2]*x)/(1+exp(beta[1]+beta[2]*x))
plot(x,y,type="l",xlab="taux de choléterole",ylab="p(x)")
abline(h=0.5,lty=2)
xlim<--beta[1]/beta[2]
abline(v=xlim,lty=2)

summary(glm(TenYearCHD~sysBP,data=data.train,family=binomial))
summary(glm(TenYearCHD~diaBP,data=data.train,family=binomial))

beta<-coef(glm(TenYearCHD~sysBP,data=data.train,family=binomial))
x<-seq(80,300,by=0.01)
y<-exp(beta[1]+beta[2]*x)/(1+exp(beta[1]+beta[2]*x))
plot(x,y,type="l",xlab="pression arterielle",ylab="p(x)")
abline(h=0.5,lty=2)
xlim<--beta[1]/beta[2]
abline(v=xlim,lty=2)


summary(glm(TenYearCHD~BMI,data=data.train,family=binomial))

beta<-coef(glm(TenYearCHD~BMI,data=data.train,family=binomial))
x<-seq(20,100,by=0.01)
y<-exp(beta[1]+beta[2]*x)/(1+exp(beta[1]+beta[2]*x))
plot(x,y,type="l",xlab="IMC",ylab="p(x)")
abline(h=0.5,lty=2)
xlim<--beta[1]/beta[2]
abline(v=xlim,lty=2)


summary(glm(TenYearCHD~heartRate,data=data.train,family=binomial))

summary(glm(TenYearCHD~glucose,data=data.train,family=binomial))

beta<-coef(glm(TenYearCHD~glucose,data=data.train,family=binomial))
x<-seq(50,350,by=0.01)
y<-exp(beta[1]+beta[2]*x)/(1+exp(beta[1]+beta[2]*x))
plot(x,y,type="l",xlab="taux de glucose",ylab="p(x)")
abline(h=0.5,lty=2)
xlim<--beta[1]/beta[2]
abline(v=xlim,lty=2)





summary(lm(sysBP~diaBP,data=data.train))

#anova 1 facteur
# fume -> tot chol

(moyennes <- aggregate(x = list(txchol_moyen = data.train$totChol),
                       by = list(smoking = data.train$is_smoking),
                       FUN = mean))

par(mfrow=c(1,1))


boxplot(data.train[, "totChol"] ~ data.train[, "is_smoking"],
        main = "taux de chol en fonction des fumeurs",
        ylab = "taux de cholestérol", xlab = "fumeurs")


modele_complet <- lm(totChol ~ is_smoking,data=data.train)
summary(modele_complet)

par(mfrow = c(2, 2))
plot(modele_complet)

#fume -> diaBP

(moyennes <- aggregate(x = list(diaBP = data.train$diaBP),
                       by = list(education = data.train$education),
                       FUN = mean))

par(mfrow=c(1,1))


boxplot(data.train[, "diaBP"] ~ data.train[, "education"],
        main = "tension artérielle en fonction du niveau d'éducation",
        ylab = "tension artérielle", xlab = "education")


modele_complet <- lm(diaBP ~ education,data=data.train)
summary(modele_complet)

#fume -> frequence cardiaque

(moyennes <- aggregate(x = list(heartRate = data.train$heartRate),
                       by = list(smoking = data.train$is_smoking),
                       FUN = mean))

par(mfrow=c(1,1))


boxplot(data.train[, "heartRate"] ~ data.train[, "is_smoking"],
        main = "fréquence cardiaque en fonction des fumeurs",
        ylab = "fréquence cardiaque", xlab = "fumeurs")


modele_complet <- lm(heartRate ~ education,data=data.train)
summary(modele_complet)

#fume -> tx de glucose

(moyennes <- aggregate(x = list(glucause = data.train$glucose),
                       by = list(smoking = data.train$is_smoking),
                       FUN = mean))

par(mfrow=c(1,1))


boxplot(data.train[, "glucose"] ~ data.train[, "is_smoking"],
        main = "taux de glucause en fonction des fumeurs",
        ylab = "taux de glucause", xlab = "fumeurs")


modele_complet <- lm(glucose ~ education,data=data.train)
summary(modele_complet)

#anova a 2 facteur
#fume + diabete = pression

sum <- ddply(data.train, .(is_smoking,diabetes), summarize, pressionmoyenne = mean(sysBP),sdPression = sd(diaBP))
kable(sum,digits=2)

ggplot(data.train, aes(x = is_smoking, y = sysBP, colour = diabetes)) +
  geom_boxplot() + theme_bw()

mod = lm(glucose~is_smoking*diabetes,data=data.train)
anova(mod)

sumdiabetes <- ddply(data.train, .(diabetes), summarize, pressionMoyenne = mean(sysBP))
kable(sumdiabetes,digits=3)

sumfume <- ddply(data.train, .(is_smoking), summarize, pressionMoyenne = mean(sysBP))
kable(sumfume,digits=3)



# fume+diabetes= pression arterielle

sum <- ddply(data.train, .(is_smoking,diabetes), summarize, moyenne_sysBP = mean(sysBP),sdt_sysBP = sd(sysBP))
kable(sum,digits=2)

ggplot(data.train, aes(x = is_smoking, y = sysBP, colour = diabetes)) +
  geom_boxplot() + theme_bw()

mod = lm(sysBP~is_smoking*diabetes,data=data.train)
anova(mod)

sumtension <- ddply(data.train, .(diabetes), summarize, txcolMoyen = mean(totChol))
kable(sumtension,digits=3)

sumfume <- ddply(data.train, .(is_smoking), summarize, txcolMoyen = mean(totChol))
kable(sumfume,digits=3)

# glucause
sum <- ddply(data.train, .(is_smoking,prevalentHyp), summarize, txglucosemoyenne = mean(glucose),sdtxcol = sd(glucose))
kable(sum,digits=2)

ggplot(data.train, aes(x = is_smoking, y = glucose, colour = prevalentHyp)) +
  geom_boxplot() + theme_bw()

mod = lm(totChol~is_smoking*prevalentHyp,data=data.train)
anova(mod)

summary(mod)

#faire l'analyse bivarié avant anova pour justifier les choix de l'anova en partie le choix + choix logique


modele_complet<-glm(TenYearCHD~.,data=data.train,family=binomial)
summary(modele_complet)

modele_selectionne<-step(modele_complet,direction="backward")
modele_selectionne
summary(modele_selectionne)

###############

scope <- list(lower = terms(tenYearCHD ~ 1, data=data.train),
              upper = terms(tenYearCHD ~ ., data=data.train))

#step.AIC <- step(null, scope, direction='both', trace=FALSE)
step.BIC <- step(modele_complet, scope, direction='both', k=log(n), trace=FALSE)

summary(step.BIC)

##############
#prediction


prevision<-predict(modele_selectionne,newdata=data.test,type="response")
prevision

data.test

classes_predites <- ifelse(prevision > 0.5, 1, 0)



# Calculer le nombre de bonnes prédictions
bonnes_predictions <- sum(classes_predites == data.test$TenYearCHD)

# Calculer le taux de bonnes prédictions
taux_bonnes_predictions <- bonnes_predictions / length(data.test$TenYearCHD)

# Afficher le taux de bonnes prédictions
cat("Taux de bonnes prédictions :", taux_bonnes_predictions)




# lorsque que le patient est reelement à risque quel est le taux de bonne reponse de prediction


#faux negatif

pred_classe1 <- classes_predites[data.test$TenYearCHD == 1]
vraies_valeurs_classe1 <- data.test$TenYearCHD[data.test$TenYearCHD == 1]

# Calculer le nombre de bonnes prédictions pour la classe réelle égale à 1
bonnes_predictions_classe1 <- sum(pred_classe1 == 1)

# Calculer le taux de bonnes prédictions pour la classe réelle égale à 1
taux_bonnes_predictions_classe1 <- bonnes_predictions_classe1 / length(pred_classe1)

# Afficher le taux de bonnes prédictions pour la classe réelle égale à 1
cat("Taux de bonnes prédictions lorsqu'un patient est reelement à risque :", taux_bonnes_predictions_classe1)
cat("faux negatif :", 1-taux_bonnes_predictions_classe1)

# lorsque la classe predite est 1, tx de similitude avec classe reel

# faux positif




pred_classe1 <- data.test$TenYearCHD[classes_predites == 1]
vraies_valeurs_classe1 <- data.test$TenYearCHD[data.test$TenYearCHD == 1]

# Calculer le nombre de bonnes prédictions pour la classe 1
bonnes_predictions_classe1 <- sum(pred_classe1 == vraies_valeurs_classe1)

# Calculer le taux de bonnes prédictions pour la classe 1
taux_bonnes_predictions_classe1 <- bonnes_predictions_classe1 / length(vraies_valeurs_classe1)

# Afficher le taux de bonnes prédictions pour la classe 1
cat("Taux de bonnes prédictions pour la classe 1 :", taux_bonnes_predictions_classe1)
cat("Taux de faux positifs:", 1-taux_bonnes_predictions_classe1)

saveRDS(modele_selectionne, file = "modele_selectionne.rds")