import os
from flask import Flask
from flask_bcrypt import Bcrypt
from flask_migrate import Migrate
from routes import bp as routes_bp

def create_app():
    from db_setup import db
    app = Flask(__name__)
    app.config['SQLALCHEMY_DATABASE_URI'] =\
    'sqlite:///' + os.path.join(app.root_path, 'database.db')
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    db.init_app(app)
    app.config['SECRET_KEY'] = 'secret_key'
    bcrypt = Bcrypt(app)

    migrate = Migrate(app, db)

    app.register_blueprint(routes_bp)
    
    return app