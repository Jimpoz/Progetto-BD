import flask
from flask import Blueprint, request
from flask_login import login_required, login_user, current_user
from flask_login import LoginManager
from datetime import datetime

login_manager = LoginManager()

bp = Blueprint('routes', __name__)
'''
@bp.route('/', methods=['GET', 'POST'])
def index():
    return flask.render_template('index.html')
'''

@bp.route('/', methods=['GET', 'POST'])
def login():
    from db_setup import Docente
    from forms import Login_form
    from flask_login import current_user
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
    user = Docente.query.get(int(current_user.idD))
    return flask.render_template('homepage.html', user=user)

@login_manager.user_loader
def load_user(user_id):
    from db_setup import Docente
    return Docente.query.get(int(user_id))



@bp.route('/create_exam', methods=['GET', 'POST'])
@login_required
def create_exam():
    from db_setup import Esame,Docente,Creazione_esame, db
    from forms import Create_Exam
    from flask_login import current_user
    
    form = Create_Exam()
    
    if form.validate_on_submit():
        idE = form.idE.data
        nome = form.nome.data
        anno_accademico = form.anno_accademico.data
        cfu = form.cfu.data
        esame = Esame(idE=idE, nome=nome, anno_accademico=anno_accademico, cfu=cfu)
        
        #if the exam already exists
        if Esame.query.filter_by(idE=idE).first() is not None:
            flask.flash('Esame già esistente')
            return flask.redirect(flask.url_for('routes.create_exam'))
        else :
            flask.flash('Esame creato con successo')
            db.session.add(esame)
            db.session.commit()
            #adding the record of the creation
            record = Creazione_esame(idE=idE, idD=current_user.idD)
            db.session.add(record)
            db.session.commit()
        
        
        
    return flask.render_template('create_exam.html', form=form)

@bp.route('/view_exams', methods=['GET', 'POST'])
@login_required
def view_exams():
    from db_setup import Esame, Creazione_esame, db
    #query that checks esame through the idE and the idD in the table Creazione_esame
    
    current_user_id = current_user.idD
    lista_esami = db.session.query(Esame).join(Creazione_esame).filter(Creazione_esame.idD == current_user_id).all()
    
    return flask.render_template('view_exams.html', lista_esami=lista_esami)

@bp.route('/search_student', methods=['GET', 'POST'])
@login_required
def search_student():
    return flask.render_template('student.html')

@bp.route('/exam_page', methods=['GET', 'POST'])
@login_required
def exam_page():
    from db_setup import Esame, Docente
    #get the exam id from the url
    idE = request.args.get('idE')
    esame = Esame.query.filter_by(idE=idE).first()
    return flask.render_template('exam_page.html', esame=esame)