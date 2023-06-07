from flask_sqlalchemy import SQLAlchemy;
from flask_login import UserMixin;
from werkzeug.security import generate_password_hash, check_password_hash
from alembic import op
from sqlalchemy import Enum

db = SQLAlchemy()

class Docente(UserMixin, db.Model):
    idD = db.Column(db.String(100), primary_key=True, unique = True)
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
    #giorno = db.Column(db.Date) -> cambiato in data_superamento e spostato in un'altra tabella
    #superato = db.Column(db.Boolean) -> eliminato
    
    #aggiunto Anno_accaedemico e CFU
    
    #CFU e idD sono stati aggiunti da SQLite
    
    def __init__( self, idE, nome, anno_accademico, cfu ):
        self.idE = idE
        self.nome = nome
        self.anno_accademico = anno_accademico
        self.cfu = cfu

class Prova( db.Model ):
    idP = db.Column(db.String(100), primary_key=True)
    nome_prova = db.Column(db.String(100))
    tipo_prova = db.Column(Enum('scritto', 'orale', 'pratico', 'completo'), name='tipo_prova')
    tipo_voto = db.Column(db.String(100))
    data = db.Column(db.Date)
    data_scadenza = db.Column(db.Date)
    idE = db.Column(db.String(100), db.ForeignKey('esame.idE'))
    idD = db.Column(db.Integer, db.ForeignKey('docente.idD'))
    
    def __init__( self, idP, idE, idD, nome_prova, tipo_prova, tipo_voto, data, data_scadenza):
        self.idP = idP
        self.idE = idE
        self.idD = idD
        self.nome_prova = nome_prova
        self.tipo_prova = tipo_prova
        self.tipo_voto = tipo_voto
        self.data = data
        self.data_scadenza = data_scadenza
    
# tabella molti a molti
class Appelli(db.Model):
    __tablename__ = 'Appelli'

    idE = db.Column(db.Integer, db.ForeignKey('esame.idE', name=None), primary_key=True)
    idS = db.Column(db.Integer, db.ForeignKey('studente.idS', name=None), primary_key=True)
    #tolto data spostato in prova
    #data_scadenza = db.Column(db.Date)
    voto = db.Column(db.Integer)
    stato_superamento = db.Column(db.Boolean)

    esame = db.relationship('Esame', backref=db.backref('appelli', cascade='all, delete-orphan'))
    studente = db.relationship('Studente', backref=db.backref('appelli', cascade='all, delete-orphan'))

    def __init__(self, idE, idS, data_superamento=None, data_scadenza=None, voto=None, stato_superamento=None):
        self.idE = idE
        self.idS = idS
        self.data_superamento = data_superamento
        self.data_scadenza = data_scadenza
        self.voto = voto
        self.stato_superamento = stato_superamento

# tabella molti a molti
class Creazione_esame(db.Model):
    __tablename__ = 'Creazione_esame'

    idD = db.Column(db.Integer, db.ForeignKey('docente.idD', name=None), primary_key=True)
    idE = db.Column(db.Integer, db.ForeignKey('esame.idE', name=None), primary_key=True)
    ruolo_docente = db.Column(Enum('Presidente', 'Membro'))

    docente = db.relationship('Docente', backref=db.backref('creazione_esame', cascade='all, delete-orphan'))
    esame = db.relationship('Esame', backref=db.backref('creazione_esame', cascade='all, delete-orphan'))

    def __init__(self, idE, idD, ruolo_docente):
        self.idE = idE
        self.idD = idD
        self.ruolo_docente = ruolo_docente

# tabella molti a molti
class Registrazione_esame(db.Model):
    __tablename__ = 'Registrazione_esame'

    idS = db.Column(db.Integer, db.ForeignKey('studente.idS', name=None), primary_key=True)
    idE = db.Column(db.Integer, db.ForeignKey('esame.idE', name=None), primary_key=True)

    studente = db.relationship('Studente', backref=db.backref('registrazione_esame', cascade='all, delete-orphan'))
    esame = db.relationship('Esame', backref=db.backref('registrazione_esame', cascade='all, delete-orphan'))

    voto = db.Column(db.Integer)
    data_superamento = db.Column(db.Date)

    def __init__(self, idS, idE, voto, data_superamento):
        self.idS = idS
        self.idE = idE
        self.voto = voto
        self.data_superamento = data_superamento