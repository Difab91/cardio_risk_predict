from flask import Flask, request, render_template
from modele import modele_cardio_risk
import pandas as pd
import rpy2.robjects as ro
from rpy2.robjects import pandas2ri
from rpy2.robjects.conversion import localconverter

app = Flask(__name__)
modele = modele_cardio_risk()
modele.charger_modele("app_modele.R")

@app.route('/')
def home():
    return render_template('form.html')

@app.route('/predict', methods=['POST'])
def predict():
    age = float(request.form['age'])
    education = float(request.form['education'])
    sex = float(request.form['sex'])
    is_smoking = float(request.form['is_smoking'])
    cigsPerDay = float(request.form['cigsPerDay'])
    BpMeds = float(request.form['BPMeds'])
    prevalentStroke = float(request.form['prevalentStroke'])
    prevalentHyp = float(request.form['prevalentHyp'])
    diabetes = float(request.form['diabetes'])
    totChol = float(request.form['totChol'])
    sysBP = float(request.form['sysBP'])
    diaBP = float(request.form['diaBP'])
    BMI = float(request.form['BMI'])
    heartRate = float(request.form['heartRate'])
    glucose = float(request.form['glucose'])

    data = pd.DataFrame({'age': [age], 'education': [education],'sex': [sex], 'is_smoking': [is_smoking],'cigsPerDay': [cigsPerDay], 'BPMeds': [BpMeds],'prevalentStroke': [prevalentStroke], 'prevalentHyp': [prevalentHyp],'diabetes': [diabetes], 'totChol': [totChol],'sysBP': [sysBP], 'diaBP': [diaBP],'BMI': [BMI], 'heartRate': [heartRate],'glucose': [glucose]})
    data['sex'] = pd.Categorical(data['sex'], categories=[0, 1], ordered=False)

    with localconverter(ro.default_converter + pandas2ri.converter):
        r_dataframe = ro.conversion.py2rpy(data)
        prediction = modele.predire(r_dataframe)

    if prediction[0]>0.5:
        return render_template('result.html', prediction="le patient est à risque de developper une maladie coronarienne dans les 10 prochaines années")
    else:
        return render_template('result.html', prediction="il y'a peu de risques pour que le patient est une maladie coronarienne dans les 10 prohaines années ")


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)


