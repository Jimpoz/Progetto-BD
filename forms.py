from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField
from wtforms.validators import InputRequired, Length, Email
from flask_bcrypt import Bcrypt

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