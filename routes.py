import flask
from flask import Blueprint
from flask_login import login_required, login_user, current_user
from flask_login import LoginManager  # Import LoginManager here

login_manager = LoginManager()

bp = Blueprint('routes', __name__)

@bp.route('/', methods=['GET', 'POST'])
def index():
    return flask.render_template('index.html')

@bp.route('/login', methods=['GET', 'POST'])
def login():
    from db_setup import Docente
    from forms import Login_form
    form = Login_form()
    
    if form.validate_on_submit():
        docente = Docente.query.filter_by(email=form.email.data).first()
        if docente is not None and docente.check_password(form.password.data):
            flask.flash('Logged in successfully.')
            login_user(docente)
            return flask.redirect(flask.url_for('routes.homepage'))
        else :
            flask.flash('Invalid username or password.')
            return flask.redirect(flask.url_for('routes.login'))
    
    return flask.render_template('login.html', form=form)

@bp.route('/logout')
@login_required
def logout():
    from flask_login import logout_user
    if current_user.is_authenticated:
        logout_user()
    return flask.redirect(flask.url_for('routes.login'))

@bp.route('/homepage')
@login_required
def homepage():
    from db_setup import Docente
    user = Docente.query.get(int(current_user.id))
    return flask.render_template('homepage.html', user=user)

@login_manager.user_loader
def load_user(docente):
    from db_setup import Docente
    return Docente.get(docente)