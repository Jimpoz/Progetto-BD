from app import *
from flask_login import login_required
from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField, ValidationError
from wtforms.validators import InputRequired, Length, ValidationError, Email
from flask_bcrypt import Bcrypt

class Login_form( FlaskForm ):
    email = StringField('Email', validators=[InputRequired(), Email(message='Invalid email'), Length(max=50)], render_kw={"placeholder": "Email"})
    password = PasswordField('Password', validators=[InputRequired(), Length(min=8, max=80)], render_kw={"placeholder": "Password"})
    
    submit = SubmitField('Login')
    
    def validate_proile(self, email, password):
        from db_setup import Docente  # import here to avoid circular import
        user = Docente.query.filter_by(email=email.data).first()
        if user:
            if Bcrypt.check_password_hash(user.password, password.data):
                return True
        return False