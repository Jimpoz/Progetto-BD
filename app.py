import flask
from flask import Flask
from flask_bcrypt import Bcrypt
from db_setup import db
import os

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] =\
    'sqlite:///' + os.path.join(app.root_path, 'database.db')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db.init_app(app)
app.config['SECRET_KEY'] = 'secret_key' #to change later
Bcrypt = Bcrypt(app)


#initialize the database
with app.app_context():
    db.create_all()

"""
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
"""

@app.route('/')
def index():
    return flask.render_template('index.html')


"""
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
"""

if __name__ == '__main__':
    app.run(debug=True)