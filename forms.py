from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField
from wtforms.validators import InputRequired, Length, Email
from flask_bcrypt import Bcrypt
from wtforms import HiddenField, StringField, SelectField, SubmitField, DateField, TimeField

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
    nome = StringField('Nome', validators=[InputRequired(), Length(max=50)], render_kw={"placeholder": "Nome"})
    idE = StringField('Id Esame', validators=[InputRequired(), Length(max=50)], render_kw={"placeholder": "Id Esame"})
    anno_accademico = StringField('Anno Accademico', validators=[InputRequired(), Length(max=50)], render_kw={"placeholder": "Anno Accademico"})
    cfu = StringField('CFU Esame', validators=[InputRequired(), Length(max=50)], render_kw={"placeholder": "CFU Esame"})
    created = HiddenField()
    submit = SubmitField('Crea Esame')
    
#da aggiungere le date della prova (data di scadenza e data della prova stessa)
class Create_Test(FlaskForm):
    idP = StringField('Id Prova', validators=[InputRequired(), Length(max=50)], render_kw={"placeholder": "Id Prova"})
    nome_prova = StringField('Nome', validators=[InputRequired(), Length(max=50)], render_kw={"placeholder": "Nome"})
    tipo_prova = SelectField('Tipo Prova', choices=[('scritto', 'Scritto'), ('orale', 'Orale'), ('pratico', 'Pratico'), ('completo', 'Completo')], validators=[InputRequired()])
    tipo_voto = StringField('Tipo Voto', validators=[InputRequired(), Length(max=50)], render_kw={"placeholder": "Tipo Voto"})
    data = DateField('Data', validators=[InputRequired()], format='%Y-%m-%d')
    ora_prova = TimeField('Ora prova', validators=[InputRequired()], format='%H:%M')
    data_scadenza = DateField('Data Scadenza', validators=[InputRequired()], format='%Y-%m-%d')
    submit = SubmitField('Crea Prova')