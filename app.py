import flask
from flask import Flask, render_template, url_for
from flask_wtf import FlaskForm
from wtforms import Form, StringField, PasswordField, validators, SubmitField, ValidationError
from flask_bcrypt import Bcrypt
from wtforms.validators import InputRequired, Length, ValidationError, Email
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///local_db.db'
app.config['SECRET_KEY'] = 'secret_key' #to change later
db = SQLAlchemy(app)
Bcrypt = Bcrypt(app)


class Registration_From( FlaskForm ):
    email = StringField('Email', validators=[InputRequired(), Email(message='Invalid email'), Length(max=50)], render_kw={"placeholder": "Email"})
    password = PasswordField('Password', validators=[InputRequired(), Length(min=8, max=80)], render_kw={"placeholder": "Password"})
    cf = StringField('Codice Fiscale', validators=[InputRequired(), Length(min=16, max=16)], render_kw={"placeholder": "Codice Fiscale"})
    name = StringField('Name', validators=[InputRequired(), Length(min=4, max=50)], render_kw={"placeholder": "Nome"})
    surname = StringField('Surname', validators=[InputRequired(), Length(min=4, max=50)], render_kw={"placeholder": "Cognome"})
    
    submit = SubmitField('Registrati')
    
    def validate_email(self, email):
        from db_setup import Docente  # import here to avoid circular import
        user = Docente.query.filter_by(email=email.data).first()
        if user:
            raise ValidationError('Email già registrata')
            
            
class Login_form( FlaskForm ):
    from db_setup import Docente  # import here to avoid circular import
    email = StringField('Email', validators=[InputRequired(), Email(message='Invalid email'), Length(max=50)], render_kw={"placeholder": "Email"})
    password = PasswordField('Password', validators=[InputRequired(), Length(min=8, max=80)], render_kw={"placeholder": "Password"})
    
    submit = SubmitField('Login')

@app.route('/')
def index():
    return flask.render_template('index.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    from db_setup import Docente  # import here to avoid circular import
    form = Login_form()
    return flask.render_template('login.html', form=form)

@app.route('/register', methods=['GET', 'POST'])
def register():
    from db_setup import Docente  # import here to avoid circular import
    form = Registration_From()
    
    if form.validate_on_submit():
        hashed_password = Bcrypt.generate_password_hash(form.password.data).decode('utf-8')
        new_user = Docente(email=form.email.data, password=hashed_password, cf=form.cf.data, name=form.name.data, surname=form.surname.data)
        db.session.add(new_user)
        db.session.commit()
    
    return flask.render_template('register.html', form=form)

if __name__ == '__main__':
    #initialize the database
    with app.app_context():
        from db_setup import Docente, Studente, Esame, Prova, Appelli, Creazione_esame, Registrazione_esame
        db.create_all()
        db.commit_session()
    app.run(debug=True)