from flask_sqlalchemy import SQLAlchemy;
from flask_login import UserMixin;
from werkzeug.security import generate_password_hash, check_password_hash
from alembic import op

db = SQLAlchemy()

class Docente(UserMixin, db.Model):
    idD = db.Column(db.Integer, primary_key=True, unique = True)
    nome = db.Column(db.String(100))
    cognome = db.Column(db.String(100))
    email = db.Column(db.String(100), unique = True)
    password = db.Column(db.String(100))
    
    def set_password(self, password):
        self.password = generate_password_hash(password)
    
    def check_password(self, password):
        return check_password_hash(self.password, password)
    
    def get_id(self):
           return (self.idD)
       
    def __init__(self, idD, nome, cognome, email, password):
        self.idD = idD
        self.nome = nome
        self.cognome = cognome
        self.email = email
        self.password = password
    
class Studente( db.Model):
    idS = db.Column(db.Integer, primary_key=True, unique = True)
    nome = db.Column(db.String(100))
    cognome = db.Column(db.String(100))
    
    def __init__(self, idS, nome, cognome):
        self.idS = idS
        self.nome = nome
        self.cognome = cognome
    
class Esame( db.Model):
    idE = db.Column(db.Integer, primary_key=True, unique = True)
    nome = db.Column(db.String(100))
    anno_accademico = db.Column(db.String(100))
    cfu = db.Column(db.Integer)
    idD = db.Column(db.Integer, db.ForeignKey('docente.idD'))
    #giorno = db.Column(db.Date) -> cambiato in data_superamento e spostato in un'altra tabella
    #superato = db.Column(db.Boolean) -> eliminato
    
    #aggiunto Anno_accaedemico e CFU
    
    #CFU e idD sono stati aggiunti da SQLite
    
    def __init__( self, idE, nome, anno_accademico, cfu, idD ):
        self.idE = idE
        self.nome = nome
        self.anno_accademico = anno_accademico
        self.cfu = cfu
        self.idD = idD
        
    
class Prova( db.Model ):
    idP = db.Column(db.Integer, primary_key=True)
    tipo = db.Column(db.String(100))
    superata = db.Column(db.Boolean)
    tipo_voto = db.Column(db.String(100))
    voto = db.Column(db.Integer)
    scadenza = db.Column(db.Date)
    idE = db.Column(db.Integer, db.ForeignKey('esame.idE'))
    
    def __init__( self, idP, tipo, superata, tipo_voto, voto, scadenza, idE ):
        self.idP = idP
        self.tipo = tipo
        self.superata = superata
        self.tipo_voto = tipo_voto
        self.voto = voto
        self.scadenza = scadenza
        self.idE = idE
    
    
class Appelli( db.Model ):
    idA = db.Column(db.Integer, primary_key=True, unique = True)
    data = db.Column(db.String(100))
    idE = db.Column(db.Integer, db.ForeignKey('esame.idE'))
    idS = db.Column(db.Integer, db.ForeignKey('studente.idS'))
    
    def __init__(self, idA, data, idE, idS):
        self.idA = idA
        self.data = data
        self.idE = idE
        self.idS = idS
    
class Creazione_esame( db.Model ):
    idC = db.Column(db.Integer, primary_key=True)
    idE = db.Column(db.Integer, db.ForeignKey('esame.idE'))
    idD = db.Column(db.Integer, db.ForeignKey('docente.idD'))
    
    def __init__(self, idC, idE, idD):
        self.idC = idC
        self.idE = idE
        self.idD = idD
    
class Registrazione_esame( db.Model ):
    idR = db.Column(db.Integer, primary_key=True)
    idE = db.Column(db.Integer, db.ForeignKey('esame.idE'))
    idS = db.Column(db.Integer, db.ForeignKey('studente.idS'))
    
    def __init__(self, idR, idE, idS):
        self.idR = idR
        self.idE = idE
        self.idS = idS