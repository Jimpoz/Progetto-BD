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

app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret!' #per adesso da cambiare

login_manager = LoginManager()
login_manager.init_app(app)
