import flask
from flask import Blueprint, request, jsonify, redirect, render_template, url_for
from flask_login import login_required, login_user, current_user
from flask_login import LoginManager
from datetime import datetime
from flask import escape
from sqlalchemy import and_

login_manager = LoginManager()

bp = Blueprint('routes', __name__)

@bp.route('/', methods=['GET', 'POST'])
def login():
    from db_setup import Docente
    from forms import Login_form
    from flask_login import current_user, logout_user
    form = Login_form()

    if current_user.is_authenticated:
        logout_user()
        flask.session.clear()

    if form.validate_on_submit():
        docente = Docente.query.filter_by(email=form.email.data).first()  # parametrizzato
        if docente is not None and docente.check_password(form.password.data):
            flask.flash('Logged in successfully.')
            login_user(docente)
            return flask.redirect(flask.url_for('routes.homepage'))
        else:
            flask.flash('Invalid username or password.')
            return flask.redirect(flask.url_for('routes.login'))

    if flask.request.referrer and 'logout' in flask.request.referrer:
        flask.flash('You need to log in to access this page.')  # Display an error message
        return flask.redirect(flask.url_for('routes.login'))

    return flask.render_template('login.html', form=form)

@bp.route('/logout')
@login_required
def logout():
    from flask_login import logout_user

    if current_user.is_authenticated:
        logout_user()

    response = flask.redirect(flask.url_for('routes.login'))
    response.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '0'
    return response


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
    import flask
    
    form = Create_Exam()
    show_popup = False
    
    if form.validate_on_submit():
        idE = form.idE.data
        nome = form.nome.data
        anno_accademico = form.anno_accademico.data
        cfu = form.cfu.data
        esame = Esame(idE=idE, nome=nome, anno_accademico=anno_accademico, cfu=cfu)
        
        if Esame.query.filter_by(idE=idE).first() is not None:
            flask.flash('Esame già esistente', 'error')
            return flask.redirect(flask.url_for('routes.create_exam', form=form, show_popup=show_popup))
        else:
            db.session.add(esame)
            db.session.commit()
            record = Creazione_esame(idE=idE, idD=current_user.idD, ruolo_docente='Presidente')
            db.session.add(record)
            db.session.commit()
            show_popup = True
            return flask.redirect(flask.url_for('routes.create_exam', form=form, show_popup=show_popup))
    
    return flask.render_template('create_exam.html', form=form, show_popup=show_popup)



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

    idE = request.args.get('idE')
    esame = db.session.query(Esame).filter(Esame.idE == idE).first()
    lista_docenti = db.session.query(Docente).all()
    lista_ruoli = (
        db.session.query(Creazione_esame.idD, Creazione_esame.ruolo_docente)
        .filter(Creazione_esame.idE == idE)
        .all()
    )

    current_user_id = current_user.idD

    # Create a new list to store docenti without a role for the specific exam
    docenti_senza_ruolo = []

    for docente in lista_docenti:
        has_role = False
        for ruolo in lista_ruoli:
            if docente.idD == ruolo.idD:
                has_role = True
                break
        if not has_role:
            docenti_senza_ruolo.append(docente)

    return flask.render_template('docenti_list.html', esame=esame, lista_docenti=docenti_senza_ruolo, lista_ruoli=lista_ruoli, current_user_id=current_user_id)

@bp.route('/docenti_list_del', methods=['GET', 'POST'])
@login_required
def docenti_list_del():
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
    
    current_user_id = current_user.idD
    
    # Create a new list to store docenti with a role for the specific exam
    docenti_con_ruolo = []
    
    for docente in lista_docenti:
        has_role = False
        for ruolo in lista_ruoli:
            if docente.idD == ruolo.idD:
                has_role = True
                break
        if has_role:
            docenti_con_ruolo.append(docente)

    return flask.render_template('docenti_list_del.html', esame=esame, lista_docenti=docenti_con_ruolo, lista_ruoli=lista_ruoli, current_user_id=current_user_id)

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
    
    user_role = (
        db.session.query(Creazione_esame.ruolo_docente)
        .filter(Creazione_esame.idE == idE, Creazione_esame.idD == current_user.idD)
        .scalar()
    )
        
    
    return flask.render_template('exam_page.html', esame=esame, lista_prove=lista_prove, lista_docenti=lista_docenti, docenti_roles=docenti_roles, user_role=user_role)

@bp.route('/redirect_to_exam_page', methods=['GET'])
@login_required
def redirect_to_exam_page():
    idE = request.args.get('idE')
    return redirect(url_for('routes.exam_page', idE=idE))


@bp.route('/create_test/<string:idE>', methods=['GET', 'POST'])
@login_required
def create_test(idE):
    from db_setup import Esame, Docente, Prova, Creazione_esame, db
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
        ora_prova = form.ora_prova.data
        ora_prova_string = ora_prova.strftime('%H:%M')
        data_scadenza = form.data_scadenza.data
        
        prova = Prova(idP=idP, idE=idE, idD=idD, nome_prova=nome_prova, tipo_prova=tipo_prova, tipo_voto=tipo_voto, data=data, ora_prova=ora_prova_string, data_scadenza=data_scadenza)
        
        if Prova.query.filter_by(idP=idP, idE=idE).first() is not None:
            flask.flash('Prova già esistente')
            return flask.redirect(flask.url_for('routes.exam_page', form=form, idE=idE))
        else:
            try:
                db.session.add(prova)
                db.session.commit()
                print("Prova added successfully")
            except Exception as e:
                print("Error committing Prova:", e)
            
            esame = Esame.query.filter_by(idE=idE).first()
            lista_docenti = db.session.query(Docente).join(Creazione_esame).filter(Creazione_esame.idE == idE).all()
            lista_prove = db.session.query(Prova).filter(Prova.idE == idE).all()
            docenti_roles = (
                db.session.query(Docente, Creazione_esame.ruolo_docente)
                .join(Creazione_esame)
                .filter(Creazione_esame.idE == idE)
                .all()
            )
            
            user_role = (
                db.session.query(Creazione_esame.ruolo_docente)
                .filter(Creazione_esame.idE == idE, Creazione_esame.idD == current_user.idD)
                .scalar()
            )
            return flask.render_template('exam_page.html', esame=esame , lista_docenti=lista_docenti, lista_prove=lista_prove, docenti_roles=docenti_roles, user_role=user_role)

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
    
    idD = current_user.idD
    
    idE = request.args.get('idE')
    
    ruolo_docente = Creazione_esame.query.filter(Creazione_esame.idD == idD, Creazione_esame.idE == idE).first()
    
    return jsonify(ruolo_docente.ruolo_docente)


@bp.route('/add_row', methods=['POST'])
@login_required
def add_row():
    from db_setup import Creazione_esame, db
    
    data = request.get_json()
    docente_id = data['docenteId']
    exam_id = data['examId']
    
    creazione_esame = Creazione_esame(idD=docente_id, idE=exam_id, ruolo_docente='Membro')
    db.session.add(creazione_esame)
    db.session.commit()
    
    #return redirect(url_for('routes.exam_page', idE=exam_id))
    return flask.render_template('exam_page.html', idE = exam_id)


@bp.route('/delete_row', methods=['POST'])
@login_required
def delete_row():
    from db_setup import Creazione_esame, db

    data = request.get_json()
    docente_id = data['docenteId']
    exam_id = data['examId']

    creazione_esame = Creazione_esame.query.filter_by(idD=docente_id, idE=exam_id).first()

    if creazione_esame:
        db.session.delete(creazione_esame)
        db.session.commit()
        flask.flash('Eliminato correttamente')
        return flask.render_template('exam_page.html', idE = exam_id)
    else:
        return flask.render_template('docenti_list_del.html', idE = exam_id)

    

@bp.route('/prova_page', methods=['GET'])
@login_required
def prova_page():
    from db_setup import Prova, Studente, Docente, Appelli, db, Esame
    
    idP = request.args.get('idP')
    prova = Prova.query.filter_by(idP=idP).first()
    lista_studenti = (
        db.session.query(Studente)
        .join(Appelli)
        .filter(Appelli.idP == idP)
        .all()
    )
    
    return flask.render_template('prova_page.html', idP=idP, prova=prova, lista_studenti=lista_studenti)

@bp.route('/student_page/<int:idS>', methods=['GET'])
@login_required
def student_page(idS):
    from db_setup import Studente, Esame, Prova, db, Appelli, Registrazione_esame
    
    studente = db.session.query(Studente).filter_by(idS=idS).first()
    
    lista_esami_iscritti = (
        db.session.query(Esame)
        .join(Prova, Esame.idE == Prova.idE)
        .join(Appelli)
        .filter(Appelli.idS == idS, Appelli.idP == Prova.idP)
        .all()
    )
    
    lista_esami_passati = (
    db.session.query(Esame)
    .join(Registrazione_esame, Esame.idE == Registrazione_esame.idE)
    .join(Appelli, and_(Appelli.idS == Registrazione_esame.idS))
    .filter(Registrazione_esame.idS == idS, Appelli.stato_superamento == True)
    .all()
    )



    return flask.render_template('student_page.html', studente=studente, lista_esami_iscritti=lista_esami_iscritti, lista_esami_passati=lista_esami_passati)

@bp.route('/delete_exam/<string:idE>', methods=['GET', 'POST'])
@login_required
def delete_exam(idE):
    from db_setup import Esame, Prova, Creazione_esame, Appelli, db

    # Retrieve the Esame object
    esame = Esame.query.filter_by(idE=idE).first()
    prove = Prova.query.filter_by(idE=idE).all()
    creazione_esame = Creazione_esame.query.filter_by(idE=idE).all()
    appelli = []
    for prova in prove:
        appelli.extend(Appelli.query.filter_by(idP=prova.idP).all())

    try:
        for appello in appelli:
            db.session.delete(appello)

        for creazione in creazione_esame:
            db.session.delete(creazione)

        for prova in prove:
            db.session.delete(prova)

        db.session.delete(esame)

        db.session.commit()
        flask.flash('Esame eliminato correttamente')
    except Exception as e:
        print("Error deleting exam:", e)


    current_user_id = current_user.idD
    lista_esami = db.session.query(Esame).join(Creazione_esame).filter(Creazione_esame.idD == current_user_id).all()
    return flask.render_template('view_exams.html', idE=idE, lista_esami=lista_esami)


@bp.route('/delete_prova/<string:idP>', methods=['GET', 'POST'])
@login_required
def delete_prova(idP):
    from db_setup import Prova, Appelli, Esame,Docente, Creazione_esame, db
    
    prova = Prova.query.filter_by(idP=idP).first()
    esame = Esame.query.filter_by(idE=prova.idE).first()
    idE = esame.idE
    #find all appelli with that prova
    appelli = Appelli.query.filter_by(idP=idP).all()
    try:
        for appello in appelli:
            db.session.delete(appello)
        db.session.delete(prova)
        db.session.commit()
        flask.flash('Prova eliminata correttamente')
    except Exception as e:
        print("Error deleting prova:", e)
    
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
    
    user_role = (
        db.session.query(Creazione_esame.ruolo_docente)
        .filter(Creazione_esame.idE == idE, Creazione_esame.idD == current_user.idD)
        .scalar()
    )
    
    return flask.render_template('exam_page.html', esame=esame , lista_docenti=lista_docenti, lista_prove=lista_prove, docenti_roles=docenti_roles, user_role=user_role)

@bp.route('/verbalizzazione/<string:idE>', methods=['GET', 'POST'])
@login_required
def verbalizzazione(idE):
    from db_setup import Esame, Prova, Appelli, Studente, Registrazione_esame, db
    #with the iDE find the exams that have Appelli.stato_superamento == True
    #for each exam show all the Appelli.voto
    
    
    
    return flask.render_template('verbalizzazione.html', idE=idE)