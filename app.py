import flask
from db_setup import db, Docente
from flask import Flask, render_template, url_for
import db_setup

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///local_db.db'
db.init_app(app)

app.config['SECRET_KEY'] = 'secret_key' #to change later

with app.app_context():
    db.create_all()
    db.session.commit()

@app.route('/')
def index():
    return flask.render_template('index.html')

@app.route('/login')
def login():
    return flask.render_template('login.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    name = flask.request.form.get('name')
    surname = flask.request.form.get('surname')
    email = flask.request.form.get('email')
    password = flask.request.form.get('password')
    
    if Docente.query.filter_by(email=email).first():
        flask.flash('Email address already registered')
        return flask.render_template('register.html')
    
    docente = Docente(nome=name, cognome=surname, email=email, password=password)
    db.session.add(docente)
    db.session.commit()
    flask.flash('Registration successful')
    return flask.render_template('register.html')

if __name__ == '__main__':
    db.create_all()
    app.run(debug=True)