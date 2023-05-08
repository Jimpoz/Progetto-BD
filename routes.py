from app import *
from forms import *


@app.route('/login', methods=['GET', 'POST'])
def login():
    from db_setup import Docente  # import here to avoid circular import
    form = Login_form()
    return flask.render_template('login.html', form=form)