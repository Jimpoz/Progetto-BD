import os
from flask import Flask
from flask_migrate import Migrate
from routes import bp as routes_bp

def create_app():
    from routes import login_manager
    from db_setup import db
    app = Flask(__name__)
    login_manager.init_app(app)
    login_manager.login_view = 'routes.login'
    app.config['SQLALCHEMY_DATABASE_URI'] =\
    'sqlite:///' + os.path.join(app.root_path, 'database.db')
    # app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://postgres:postgres@localhost:5432/Flask'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
    db.init_app(app)
    app.config['SECRET_KEY'] = 'secret_key'

    migrate = Migrate(app, db)

    app.register_blueprint(routes_bp)
    
    return app