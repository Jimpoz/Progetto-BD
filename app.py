import flask
from flask import Flask, render_template, url_for;
from flask_sqlalchemy import SQLAlchemy;
from flask_login import UserMixin;

app = Flask(__name__)
db = SQLAlchemy() #the app inside the brackets was not needed
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///local_db.db'
app.config['SECRET_KEY'] = 'secret_key' #to change later

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

@app.route('/')
def index():
    return flask.render_template('index.html')

@app.route('/login')
def login():
    return flask.render_template('login.html')

@app.route('/signup')
def signup():
    return flask.render_template('signup.html')

@app.route('/register')
def register():
    return flask.render_template('register.html')

if __name__ == '__main__':
    app.run(debug=True)
