import flask
from flask import Blueprint
from forms import *
from flask_login import login_required

bp = Blueprint('routes', __name__)

@bp.route('/', methods=['GET', 'POST'])
def index():
    return flask.render_template('index.html')

@bp.route('/login', methods=['GET', 'POST'])
@login_required
def login():
    from db_setup import Docente  # import here to avoid circular import
    form = Login_form()
    return flask.render_template('login.html', form=form)

def load_user(user_id):
    from db_setup import Docente  # import here to avoid circular import
    return Docente.query.get(int(user_id))