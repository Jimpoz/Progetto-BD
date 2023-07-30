import os
from flask import Flask
from flask_migrate import Migrate
from routes import bp as routes_bp
##carico le variabili d'ambiente contenute nel file .env
from dotenv import load_dotenv
load_dotenv()

def create_app():
    from routes import login_manager
    from db_setup import db

    app = Flask(__name__)
    login_manager.init_app(app)
    login_manager.login_view = 'routes.login'
    app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DATABASE_URL')
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

    db.init_app(app)
    app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY')

    migrate = Migrate(app, db)

    app.register_blueprint(routes_bp)
    
    return app