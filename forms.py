from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField
from wtforms.validators import InputRequired, Length, Email
from flask_bcrypt import Bcrypt
from wtforms import HiddenField, StringField, SelectField, SubmitField

class Login_form( FlaskForm ):
    email = StringField('Email', validators=[InputRequired(), Email(message='Invalid email'), Length(max=50)], render_kw={"placeholder": "Email"})
    password = PasswordField('Password', validators=[InputRequired(), Length(max=80)], render_kw={"placeholder": "Password"})
    
    submit = SubmitField('Login')
    
    def validate_profile(self, email, password):
        from db_setup import Docente 
        user = Docente.query.filter_by(email=email.data).first()
        if user:
            if Bcrypt.check_password_hash(user.password, password.data):
                return True
        return False
    
    
class Create_Exam( FlaskForm ):
    from db_setup import Esame, Docente
    from routes import current_user
    
    idD = Docente.query.get(int(current_user.idD))
    nome = StringField('Nome', validators=[InputRequired(), Length(max=50)], render_kw={"placeholder": "Nome"})
    idE = StringField('Id Esame', validators=[InputRequired(), Length(max=50)], render_kw={"placeholder": "Id Esame"})
    TipoEsame = SelectField('Tipo Esame', choices=[('Esame', 'Esame'), ('Prova', 'Prova')], validators=[InputRequired()])

class Add_Exam( FlaskForm ):
    from db_setup import Esame, Docente
    from routes import current_user
    
    idD = Docente.query.get(int(current_user.idD))
    idE = StringField('Id Esame', validators=[InputRequired(), Length(max=50)], render_kw={"placeholder": "Id Esame"})
    nome = StringField('Nome', validators=[InputRequired(), Length(max=50)], render_kw={"placeholder": "Nome"})
    #giorno = SelectField('Giorno', choices=)
    CFU = SelectField('CFU', choices=[('3', '3'), ('6', '6'), ('12', '12')], validators=[InputRequired()])
    
    
    submit = SubmitField('Crea Esame')
    
class Add_Prova( FlaskForm ):
    from db_setup import Prova, Docente
    from routes import current_user
    
    idD = Docente.query.get(int(current_user.idD))
    idP = StringField('Id Prova', validators=[InputRequired(), Length(max=50)], render_kw={"placeholder": "Id Prova"})
    nome = StringField('Nome', validators=[InputRequired(), Length(max=50)], render_kw={"placeholder": "Nome"})
    tipo = SelectField('Tipo', choices=[('Scritto', 'Scritto'), ('Orale', 'Orale'), ('Pratico', 'Pratico')], validators=[InputRequired()])
    #giorno = SelectField('Giorno', choices=)
    