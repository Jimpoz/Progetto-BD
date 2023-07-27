import flask
from flask import Blueprint, request, jsonify, redirect, render_template, url_for
from flask_login import login_required, login_user, current_user
from flask_login import LoginManager
from datetime import datetime
from flask import escape
from sqlalchemy import and_, func, not_, or_, any_, exists, case, cast, String
from sqlalchemy.orm import joinedload

login_manager = LoginManager()

bp = Blueprint('routes', __name__)

@bp.route('/', methods=['GET', 'POST'])
def login():
    from db_setup import Docente
    from forms import Login_form
    from flask_login import current_user, logout_user, login_user
    from werkzeug.security import check_password_hash
    form = Login_form()

    if current_user.is_authenticated:
        return flask.redirect(flask.url_for('routes.logout'))  # Redirect to the logout route

    if form.validate_on_submit():
        docente = Docente.query.filter_by(email=form.email.data).first()  # parametrizzato
        if not docente or not check_password_hash(docente.password, form.password.data):
            flask.flash('Invalid username or password.')
            return flask.redirect(flask.url_for('routes.login'))
        else:
            login_user(docente)
            flask.flash('Logged in successfully.')
            return flask.redirect(flask.url_for('routes.homepage'))  # Redirect to the homepage route

    if flask.request.referrer and 'logout' in flask.request.referrer:
        flask.flash('You need to log in to access this page.')  # Display an error message
    
    return flask.render_template('login.html', form=form)


@bp.route('/logout', methods=['GET', 'POST'])
@login_required
def logout():
    from flask_login import logout_user
    
    if current_user.is_authenticated:
        logout_user()
        flask.session.clear()

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
    from flask import request, flash, redirect, render_template, url_for
    from flask_login import current_user

    form = Create_Exam()
    show_popup = False

    if form.validate_on_submit():
        idE = form.idE.data
        nome = form.nome.data
        anno_accademico = form.anno_accademico.data
        cfu = form.cfu.data

        # Check if the Esame already exists
        if Esame.query.filter_by(idE=idE).first():
            flash('Esame già esistente', 'error')
        else:
            # Add the new Esame to the database
            esame = Esame(idE=idE, nome=nome, anno_accademico=anno_accademico, cfu=cfu)
            db.session.add(esame)
            db.session.commit()

            # Add the record to Creazione_esame
            record = Creazione_esame(idE=idE, idD=current_user.idD, ruolo_docente='Presidente')
            db.session.add(record)
            db.session.commit()

            show_popup = True
            flash('Esame creato con successo', 'success')

    return render_template('create_exam.html', form=form, show_popup=show_popup)

@bp.route('/view_exams', methods=['GET', 'POST'])
@login_required
def view_exams():
    from db_setup import Esame, Creazione_esame, db
    
    #query that checks esame through the idE and the idD in the table Creazione_esame
    current_user_id = current_user.idD
    lista_esami = db.session.query(Esame).join(Creazione_esame).filter(Creazione_esame.idD == current_user_id).all()
    
    return flask.render_template('view_exams.html', lista_esami=lista_esami)

from sqlalchemy import or_, cast, String
from db_setup import Studente, Docente, db

@bp.route('/search_student', methods=['GET', 'POST'])
@login_required
def search_student():
    if request.method == 'POST':
        search_query = request.form['search']
        
        # Add the percentage signs to the search_query for partial matching
        search_query_with_wildcard = f"%{search_query}%"

        # Query students based on matricola (idS), Nome, Cognome, Nome + Cognome, or Cognome + Nome
        query = db.session.query(Studente).filter(
            or_(
                cast(Studente.idS, String).ilike(search_query_with_wildcard),
                cast(Studente.nome, String).ilike(search_query_with_wildcard),
                cast(Studente.cognome, String).ilike(search_query_with_wildcard),
                cast(Studente.nome + ' ' + Studente.cognome, String).ilike(search_query_with_wildcard),
                cast(Studente.cognome + ' ' + Studente.nome, String).ilike(search_query_with_wildcard)
            )
        ).all()

        lista_studenti = query
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
        percentuale = form.percentuale.data
        data = form.data.data
        ora_prova = form.ora_prova.data
        ora_prova_string = ora_prova.strftime('%H:%M')
        data_scadenza = form.data_scadenza.data
        
        prova = Prova(idP=idP, idE=idE, idD=idD, nome_prova=nome_prova, tipo_prova=tipo_prova, tipo_voto=tipo_voto, percentuale=percentuale ,data=data, ora_prova=ora_prova_string, data_scadenza=data_scadenza)
        
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
    
    #show the ones that have at least one Appelli.stato_superamento = False
    lista_esami_iscritti = (
        db.session.query(Esame)
        .join(Prova, Esame.idE == Prova.idE)
        .join(Appelli)
        .filter(Appelli.idS == idS, Appelli.idP == Prova.idP, Appelli.stato_superamento == False)
        .all()
    )
    
    #lista_esami_passati is the list of exams that the student has passed, meaning that all the Prova must have the stato_superamento = True
    # and the sum of their percentage must be 100
    lista_esami_passati = (
        db.session.query(Esame)
        .join(Prova, Esame.idE == Prova.idE)
        .join(Appelli)
        .filter(Appelli.idS == idS, Appelli.idP == Prova.idP, Appelli.stato_superamento == True)
        .group_by(Esame.idE)
        .having(func.sum(Prova.percentuale) == 100)
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
    from db_setup import Prova, Appelli, Esame, Docente, Creazione_esame, db

    prova = Prova.query.get(idP)
    if not prova:
        return flask.flash('Prova not found', 'error')

    esame = Esame.query.filter_by(idE=prova.idE).first()
    idE = esame.idE

    appelli = Appelli.query.filter_by(idP=idP).all()
    try:
        for appello in appelli:
            db.session.delete(appello)
        db.session.delete(prova)
        db.session.commit()
        flask.flash('Prova eliminata correttamente', 'success')
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

@bp.route('/modify_exam/<string:idE>', methods=['GET', 'POST'])
@login_required
def modify_exam(idE):

    from db_setup import Esame, db
    from forms import Modify_Exam

    esame = Esame.query.filter_by(idE=idE).first()
    form = Modify_Exam(obj=esame)
    
   
    if form.validate_on_submit():
        form.populate_obj(esame)
        idE = form.idE.data
        nome = form.nome.data
        anno_accademico = form.anno_accademico.data
        cfu = form.cfu.data
    
        esame=db.session.query(Esame).filter(Esame.idE == idE).first()
        esame.idE=idE
        esame.nome=nome
        esame.anno_accademico=anno_accademico
        esame.cfu=cfu
        db.session.commit()
        return redirect(url_for('routes.exam_page', idE=idE))
    
    flask.flash('Esame aggiornato')
    esame=db.session.query(Esame).filter(Esame.idE == idE).first()
    
    return flask.render_template('modify_exam.html', form=form, idE=idE, esame=esame)
'''
@DEPRECATED

the button in the html file

<!--<button id="button_modifica_prova" type="button" onclick="window.location.href='{{url_for('routes.modify_test', idP=prova.idP)}}'" class="btn btn-primary">Modifica prova</button>-->

@bp.route('/modify_test/<string:idP>', methods=['GET', 'POST'])
@login_required
def modify_test(idP):
    from db_setup import Prova, Studente, Appelli, db
    from forms import Modify_Test

    prova = Prova.query.filter_by(idP=idP).first()

    if prova is None:
        # Handle the case when the prova with the given idP doesn't exist
        flask.flash('Prova not found', 'error')
        return redirect(url_for('routes.view_tests'))

    form = Modify_Test(obj=prova)

    if form.validate_on_submit():
        print("Form validated")
        form.populate_obj(prova)
        db.session.commit()
        flask.flash('Prova changed successfully', 'success')
        return redirect(url_for('routes.prova_page', idP=idP))

    lista_studenti = (
        db.session.query(Studente)
        .join(Appelli)
        .filter(Appelli.idP == idP)
        .all()
    )

    return render_template('modify_test.html', form=form, idP=idP, prova=prova, lista_studenti=lista_studenti)
'''   

@bp.route('/verbalizza/<string:idE>', methods=['GET', 'POST'])
@login_required
def verbalizza(idE):
    from db_setup import Studente, db, Appelli, Prova, Esame, Registrazione_esame
    
    #deletes from the database all appelli with stato_superamento = False
    #seeing the appelli with a voto = None is not necessary
    db.session.query(Appelli).filter(Appelli.stato_superamento == False).delete()
    db.session.commit()
    
    #SELECT s.ids, p.idp, p.data, p.data_scadenza, p.tipo_voto, p.percentuale, a.voto
    #FROM studente s join appelli a using(idS) join prova p using (idP)
    #WHERE s.idS IN (SELECT idS FROM appelli WHERE stato_superamento = "True")
    subquery = (
        db.session.query(Appelli.idS)
        .join(Prova, Prova.idP == Appelli.idP)
        .filter(Appelli.stato_superamento == True, Prova.idE == idE)
        .group_by(Appelli.idS)
        .having(func.sum(Prova.percentuale) == 100 and func.sum(Prova.percentuale) <=100)
        .subquery()
    )

    lista_voti_studenti = (
        db.session.query(Studente.idS, Prova.idP, Prova.data, Prova.data_scadenza, Prova.tipo_voto, Prova.percentuale, Appelli.voto)
        .join(Appelli, Studente.idS == Appelli.idS)
        .join(Prova, Prova.idP == Appelli.idP)
        .filter(Studente.idS.in_(subquery))
        #.group_by(Studente.idS, Prova.idP, Appelli.voto)
        #.having(func.sum(Prova.percentuale) == 100)
        .all()
    )
    
    return flask.render_template('verbalizzazione.html', lista_voti_studenti=lista_voti_studenti, idE=idE)




from datetime import datetime, date
# ...

from flask import request, jsonify
from datetime import datetime
from db_setup import db, Registrazione_esame, Appelli

@bp.route('/verbalizza_voti/<string:idE>', methods=['POST'])
@login_required
def verbalizza_voti(idE):
    if request.method == 'POST':
        matricola_totals = request.get_json()

        # Process the matricola_totals dictionary and add voto for each matricola
        for matricola, total in matricola_totals.items():
            try:
                matricola_id = int(matricola)  # Convert the matricola to an integer
            except ValueError:
                return jsonify({"error": "Invalid student ID"}), 400

            date = datetime.now()
            voto = Registrazione_esame(idS=matricola_id, idE=idE, voto=total, data_superamento=date)
            db.session.add(voto)

        db.session.commit()
        print("Voti added successfully")
        return jsonify({"message": "Data received and processed successfully"}), 200
    else:
        return redirect(url_for('routes.verbalizza', idE=idE))
