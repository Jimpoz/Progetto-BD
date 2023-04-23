import flask;
from db_setup import db, Docente;
from flask import Flask, render_template, url_for;

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///local_db.db'
db.init_app(app)

app.config['SECRET_KEY'] = 'secret_key' #to change later


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
