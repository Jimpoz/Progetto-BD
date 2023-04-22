import flask
from flask_sqlalchemy import SQLAlchemy;
from flask_login import UserMixin;

db = SQLAlchemy() #the app inside the brackets was not needed
#Test class
class Docente(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    nome = db.Column(db.String(100))
    cognome = db.Column(db.String(100))
    email = db.Column(db.String(100))
    password = db.Column(db.String(100))
    #def __init__(self, nome, cognome, email, password):
    #    self.nome = nome
    #    self.cognome = cognome
    #    self.email = email
    #    self.password = password