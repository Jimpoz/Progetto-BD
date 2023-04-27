import flask
from flask_sqlalchemy import SQLAlchemy;
from flask_login import UserMixin;

db = SQLAlchemy() #the app inside the brackets was not needed
#Test class
class Docente(UserMixin, db.Model):
    idD = db.Column(db.Integer, primary_key=True)
    nome = db.Column(db.String(100))
    cognome = db.Column(db.String(100))
    email = db.Column(db.String(100))
    password = db.Column(db.String(100))
    
class Studente( db.Model):
    idS = db.Column(db.Integer, primary_key=True)
    nome = db.Column(db.String(100))
    cognome = db.Column(db.String(100))
    
class Esame( db.Model):
    idE = db.Column(db.Integer, primary_key=True)
    nome = db.Column(db.String(100))
    giorno = db.Column(db.Date)
    superato = db.Column(db.Boolean)
    
class Prova( db.Model ):
    idP = db.Column(db.Integer, primary_key=True)
    tipo = db.Column(db.String(100))
    superata = db.Column(db.Boolean)
    voto = db.Column(db.Integer)
    scadenza = db.Column(db.Date)
    idE = db.Column(db.Integer, db.ForeignKey('esame.idE'))
    
    
class Appelli( db.Model ):
    idA = db.Column(db.Integer, primary_key=True)
    data = db.Column(db.String(100))
    idE = db.Column(db.Integer, db.ForeignKey('esame.idE'))
    idS = db.Column(db.Integer, db.ForeignKey('studente.idS'))
    
class Creazione_esame( db.Model ):
    idC = db.Column(db.Integer, primary_key=True)
    idE = db.Column(db.Integer, db.ForeignKey('esame.idE'))
    idD = db.Column(db.Integer, db.ForeignKey('docente.idD'))
    
class Registrazione_esame( db.Model ):
    idR = db.Column(db.Integer, primary_key=True)
    idE = db.Column(db.Integer, db.ForeignKey('esame.idE'))
    idS = db.Column(db.Integer, db.ForeignKey('studente.idS'))