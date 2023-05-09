import flask
from flask import Blueprint
from flask_login import login_required

bp = Blueprint('routes', __name__)

@bp.route('/', methods=['GET', 'POST'])
def index():
    return flask.render_template('index.html')

@bp.route('/login', methods=['GET', 'POST'])
def login():
    from db_setup import Docente
    from forms import Login_form, login_user
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

@bp.route('/homepage', methods=['GET', 'POST'])
@login_required
def homepage():
    return flask.render_template('homepage.html')

def load_user(user_id):
    from db_setup import Docente  # import here to avoid circular import
    return Docente.query.get(int(user_id))