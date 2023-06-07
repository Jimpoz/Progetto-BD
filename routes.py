import flask
from flask import Blueprint, request, jsonify, redirect, render_template, url_for
from flask_login import login_required, login_user, current_user
from flask_login import LoginManager
from datetime import datetime

login_manager = LoginManager()

bp = Blueprint('routes', __name__)

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
    user = Docente.query.get(current_user.idD)
    return flask.render_template('homepage.html', user=user)

@login_manager.user_loader
def load_user(user_id):
    from db_setup import Docente
    return Docente.query.get(user_id)

@bp.route('/create_exam', methods=['GET', 'POST'])
@login_required
def create_exam():
    from db_setup import Esame, Docente, Creazione_esame, db
    from forms import Create_Exam
    from flask_login import current_user
    
    form = Create_Exam()
    
    if form.validate_on_submit():
        idE = form.idE.data
        nome = form.nome.data
        anno_accademico = form.anno_accademico.data
        cfu = form.cfu.data
        esame = Esame(idE=idE, nome=nome, anno_accademico=anno_accademico, cfu=cfu)
        
        # if the exam already exists
        if Esame.query.filter_by(idE=idE).first() is not None:
            flask.flash('Esame già esistente')
            return flask.redirect(flask.url_for('routes.create_exam'))
        else:
            flask.flash('Esame creato con successo')
            db.session.add(esame)
            db.session.commit()
            record = Creazione_esame(idE=idE, idD=current_user.idD, ruolo_docente='Presidente')
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
    from db_setup import Studente, Docente, db
    if request.method == 'POST':
        search_query = request.form['search']
        
        # Query that checks studente through the matricola with the like operator
        query = db.session.query(Studente).filter(Studente.idS.like('%'+search_query+'%')).all()
        
        lista_studenti = query
        user = Docente.query.get(current_user.idD)
        
        return flask.render_template('student_list.html', user=user, lista_studenti=lista_studenti)
    
    # Fetch all students if it's a GET request
    lista_studenti = db.session.query(Studente).all()
    user = Docente.query.get(current_user.idD)
    
    return flask.render_template('student_list.html', user=user, lista_studenti=lista_studenti)

@bp.route('/docenti_list', methods=['GET', 'POST'])
@login_required
def docenti_list():
    from db_setup import Docente, Esame, db, Creazione_esame
    # Get the exam id from the URL
    idE = request.args.get('idE')
    esame = db.session.query(Esame).filter(Esame.idE == idE).first()
    lista_docenti = db.session.query(Docente).all()

    # Fetch the roles of the professors for the specific exam
    lista_ruoli = (
        db.session.query(Creazione_esame.idD, Creazione_esame.ruolo_docente)
        .filter(Creazione_esame.idE == idE)
        .all()
    )

    return flask.render_template('docenti_list.html', esame=esame, lista_docenti=lista_docenti, lista_ruoli=lista_ruoli)

@bp.route('/exam_page', methods=['GET', 'POST'])
@login_required
def exam_page():
    from db_setup import Esame, Docente, Prova, db, Creazione_esame
    #get the exam id from the url
    idE = request.args.get('idE')
    esame = Esame.query.filter_by(idE=idE).first()
    #query that returns all of the professors of the exam through the idE and the idD in the table Creazione_esame
    lista_docenti = db.session.query(Docente).join(Creazione_esame).filter(Creazione_esame.idE == idE).all()
    
    #query that returns all of the tests of the exam through the idE and the idD in the table Prova
    lista_prove = db.session.query(Prova).filter(Prova.idE == idE).all()
    
    docenti_roles = (
        db.session.query(Docente, Creazione_esame.ruolo_docente)
        .join(Creazione_esame)
        .filter(Creazione_esame.idE == idE)
        .all()
    )
    
    return flask.render_template('exam_page.html', esame=esame, lista_prove=lista_prove, lista_docenti=lista_docenti, docenti_roles=docenti_roles)

@bp.route('/redirect_to_exam_page', methods=['GET'])
@login_required
def redirect_to_exam_page():
    idE = request.args.get('idE')
    return redirect(url_for('routes.exam_page', idE=idE))


@bp.route('/create_test/<string:idE>', methods=['GET', 'POST'])
@login_required
def create_test(idE):
    from db_setup import Esame, Docente, Prova, db
    from forms import Create_Test
    from flask_login import current_user
    
    form = Create_Test()
    
    if form.validate_on_submit():
        idP = form.idP.data
        idD = current_user.idD
        nome_prova = form.nome_prova.data
        tipo_prova = form.tipo_prova.data
        tipo_voto = form.tipo_voto.data
        data = form.data.data
        data_scadenza = form.data_scadenza.data
        #da aggiungere data e scadenza
        
        prova = Prova(idP=idP, idE=idE, idD=idD, nome_prova=nome_prova, tipo_prova=tipo_prova, tipo_voto=tipo_voto, data=data, data_scadenza=data_scadenza)
        
        if Prova.query.filter_by(idP=idP, idE=idE).first() is not None:
            flask.flash('Prova già esistente')
            return flask.redirect(flask.url_for('routes.create_test', form=form, idE=idE))
        else:
            try:
                db.session.add(prova)
                db.session.commit()
                print("Prova added successfully")
            except Exception as e:
                print("Error committing Prova:", e)
            
            return flask.redirect(flask.url_for('routes.create_test',form=form, idE=idE))

    return flask.render_template('create_test.html', form=form, idE=idE)
    

@bp.route('/get_all_docenti', methods=['GET'])
@login_required
def get_all_docenti():
    from db_setup import Docente,Esame, db, Creazione_esame
    
    idD = current_user.idD
    
    idE = request.args.get('idE')

    docenti = Docente.query.all()
    
    docenti_roles = (
        db.session.query(Docente, Creazione_esame.ruolo_docente)
        .join(Creazione_esame)
        .filter(Creazione_esame.idE == idE)
        .all()
    )

    docenti_data = [{'idD': docente.idD, 'nome': docente.nome, 'cognome': docente.cognome} for docente in docenti]
    #return jsonify(docenti_data)

    return flask.render_template('docenti_list.html', docenti_data=docenti_data, docenti_roles=docenti_roles, idE=idE)

@bp.route('/get_role', methods=['GET'])
@login_required
def get_role():
    from db_setup import Creazione_esame, db
    
    # Get the current user id
    idD = current_user.idD
    
    # Get the exam id from the URL
    idE = request.args.get('idE')
    
    # Query the Creazione_esame table to retrieve the ruolo_docente
    ruolo_docente = Creazione_esame.query.filter(Creazione_esame.idD == idD, Creazione_esame.idE == idE).first()
    
    return jsonify(ruolo_docente.ruolo_docente)


@bp.route('/add_row', methods=['POST'])
@login_required
def add_row():
    from db_setup import Creazione_esame, db
    
    # Get the data from the request body
    data = request.get_json()
    docente_id = data['docenteId']
    exam_id = data['examId']
    
    # Create a new row in the Creazione_esame table
    creazione_esame = Creazione_esame(idD=docente_id, idE=exam_id, ruolo_docente='Membro')
    db.session.add(creazione_esame)
    db.session.commit()
    
    # Redirect to the exam_page.html
    return redirect(url_for('routes.exam_page', idE=exam_id))

#da finire
@bp.route('/student', methods=['GET', 'POST'])
@login_required
def student():
    from db_setup import Studente,Esame, Prova, db