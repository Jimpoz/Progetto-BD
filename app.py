#create config
#create users structure
#create login structure
#create login page
#create login function
#create logout function
#create home page
#create home page function
#create register page
#create register function
#create profile page
#create profile function
#create profile edit page
#create profile edit function


import flask
from flask import *;
from flask_login import *
from flask import Flask, render_template, request, redirect, url_for, session

app = Flask(__name__)
app.secret_key = 'supersecretkey'

# Pagina di benvenuto
@app.route('/')
def welcome():
    return render_template('welcome.html')

# Login
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        # Verifica le credenziali
        username = request.form['username']
        password = request.form['password']
        if username == 'admin' and password == 'admin':
            # Login valido, crea la sessione
            session['username'] = username
            return redirect(url_for('dashboard'))
        else:
            # Login fallito, mostra un messaggio di errore
            return render_template('login.html', error='Credenziali non valide')
    else:
        # Mostra la pagina di login
        return render_template('login.html')

# Area riservata
@app.route('/dashboard')
def dashboard():
    if 'username' in session:
        # Utente autenticato, mostra il pannello di controllo
        return render_template('dashboard.html', username=session['username'])
    else:
        # Utente non autenticato, reindirizza alla pagina di login
        return redirect(url_for('login'))

# Logout
@app.route('/logout')
def logout():
    # Rimuovi la sessione e reindirizza alla pagina di login
    session.pop('username', None)
    return redirect(url_for('login'))