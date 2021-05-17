
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
from werkzeug.security import generate_password_hash, check_password_hash
from flask import Flask, redirect, url_for, request, jsonify, json, session
from kubernetes.client.apis import core_v1_api
from flask_sqlalchemy  import SQLAlchemy
from flask_httpauth import HTTPBasicAuth
from kubernetes  import client, config
from os import path
import subprocess
import argparse
import smtplib
import random
import yaml
import time
import uuid
import os
import logging

auth = HTTPBasicAuth()
app = Flask(__name__)
logger = logging.getLogger()
parser = argparse.ArgumentParser(description="FuchiCorp Api Application.")
parser.add_argument("--debug", action='store_true', help="Run Application on developer mode.")
version = 'v0.1'
args = parser.parse_args()
def app_set_up():
    """
        If parse --debug argument to the application.
        Applicaion will run on debug mode and local mode.
        It's useful when you are developing application on localhost
        config-file: debug-config.cfg
    """
    if args.debug:

        ## To testing I create my own config make sure you have configured ~/.kube/config
        current_folder = os.getcwd()
        app.config.from_pyfile(f'{current_folder}/debug-config.cfg')
        # print('Using config: /Users/fsadykov/backup/databases/config.cfg')
    else:

        ## To different enviroments enable this
        app.config.from_pyfile('config.cfg')
        os.system('sh bash/bin/getServiceAccountConfig.sh')

app_set_up()
db = SQLAlchemy(app)
env = app.config.get('BRANCH_NAME')
if env == 'master':
    enviroment = 'prod'
else:
    enviroment = env

def is_prod():
    if enviroment.lower() != 'master':
        return False
    return True
    
if not is_prod():
    app.testing = True

## Loading the Kubernetes configuration
# config.load_kube_config()
# kube = client.ExtensionsV1beta1Api()
# api = core_v1_api.CoreV1Api()

login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'

@auth.verify_password
def verify_password(username, password):
    user = User.query.filter_by(username = username).first()
    if not user or not user.verify_password(password):
        return False
    return True

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))


class Message(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50))
    message = db.Column(db.String(500))

class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    firstname = db.Column(db.String(15))
    lastname = db.Column(db.String(15))
    username = db.Column(db.String(30), unique=True)
    email = db.Column(db.String(50), unique=True)
    password = db.Column(db.String(80))
    status = db.Column(db.String(5))
    role = db.Column(db.String(20))
    def verify_password(self, password):
        if check_password_hash(self.password, password):
            return True
        else:
            return False

    def __repr__(self):
        return '<User %r>' % self.username

class Pynote(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    server_name = db.Column(db.String(50))
    username = db.Column(db.String(50))
    password = db.Column(db.String(50))
    pynotelink = db.Column(db.String(50), unique=True)
    port = db.Column(db.Integer, unique=True)
    def __repr__(self):
        return '<User %r>' % self.username

class ExampleUsers(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id     = db.Column(db.String(100), unique=True)
    firstname   = db.Column(db.String(15))
    lastname    = db.Column(db.String(15))
    username    = db.Column(db.String(30), unique=True)
    email       = db.Column(db.String(50), unique=True)
    password    = db.Column(db.String(200))
    status      = db.Column(db.String(10))
    email_confm = db.Column(db.Integer, unique=True)
    def verify_password(self, password):
        if check_password_hash(self.password, password):
            return True
        else:
            return False

    def __repr__(self):
        return '<User %r>' % self.username


### Api Block starts from here ####

@app.route(f'/{version}/users', methods=['GET'])
@auth.login_required
def api_users():
    users = User.query.all()
    return_object = []
    for user in users:
        return_object.append({'password': user.password, 'username': user.username, 'email': user.email, 'status': user.status, 'role': user.role})
    return jsonify(return_object)

#### Get list of example users
@app.route('/', methods=['GET'])
def index():
    object = {
        "message": "Welcome to FuchiCorp API",
        "status" : 200,
        "anonymus": True,
        "owner": "Farkhod Sadykov",
        "email": "fuchicorpsolution@gmail.com"
        }
    return jsonify(object)


#### Get list of example users
@app.route(f'/{version}/example/users', methods=['GET'])
def get_example_users():
    users = ExampleUsers.query.all()
    return_object = []
    for user in users:
        return_object.append({
        'UUID': user.user_id,
        'password' : user.password,
        'firstname' : user.firstname,
        'lastname' : user.lastname,
        'username' : user.username,
        'email' : user.email,
        'status' : user.status})
    return jsonify(return_object)


## Create an example user
@app.route(f'/{version}/create_example/user', methods=['POST'])
def create_example_users():
    """
        This page has been created for FuchiCorp members. In this page user should be able to create user.
         keys:
             firstname lastname email username password
         response:
            <User has been created!!>
    """
    try:
        data = json.loads(request.data)
    except Exception as err:
        return jsonify({"message": "Erro {}".format(err)})
    try:
        data_base_user = ExampleUsers.query.filter_by(username=data['username']).first()
        if not data_base_user:
            generated_password = generate_password_hash(data['password'], method='sha256')
            new_user = ExampleUsers(username=data['username'], password=generated_password,
            firstname=data['firstname'], lastname=data['lastname'], email=data['email'], user_id=str(uuid.uuid4()), status=False)
            db.session.add(new_user)
            db.session.commit()
            return jsonify({'message': 'User has been created!!'})

        return jsonify({'message': 'User already exist in system!!'})
    except Exception as err:
        return jsonify({"message": "Missing key {}".format(err)})




## Create an example user
@app.route(f'/{version}/update_example/user/<user_id>', methods=['PUT'])
def update_example_users(user_id=None):
    """
        This page has been created for FuchiCorp members. In this page user should be able to update user.
         keys:
             firstname lastname email username password
         response:
            <User information has been updated!!>
    """
    try:
        data = json.loads(request.data)
    except Exception as err:
        return jsonify({"message": "Erro {}".format(err)})
    try:
        data_base_user = ExampleUsers.query.filter_by(username=data['username']).first()

        if data_base_user:
            if data_base_user.username == data['username'] and data_base_user.verify_password(data['password']):
                data_base_user.username=data['username']
                data_base_user.password=generate_password_hash(data['password'], method='sha256')
                data_base_user.firstname=data['firstname']
                data_base_user.lastname=data['lastname']
                data_base_user.email=data['email']
                db.session.commit()
                return jsonify({'message': 'User information has been updated!!'})
            else:
                return jsonify({"message": "User name or password is invalid"})

        return jsonify({'message': 'User already exist in system!!'})
    except Exception as err:
        return jsonify({"message": "Missing key {}".format(err)})




## Delete an example user
@app.route(f'/{version}/delete_example/user/<user_id>', methods=['DELETE'])
def delete_example_user(user_id=None):
    """
        This page has been created for FuchiCorp members. In this page user should be able to delete user.
        path:
            <version>/delete_example/user/<user_id>
        keys:
             username password
        200 response:
            <User has been deleted!!>
    """
    try:
        data = json.loads(request.data)
    except Exception as err:
        return jsonify({"message": "Error reading JSON data {}".format(err)})

    try:
        data_base_user = ExampleUsers.query.filter_by(user_id=user_id).first()
        if data_base_user:
            if data_base_user.username == data['username'] and data_base_user.verify_password(data['password']):
                db.session.delete(data_base_user)
                db.session.commit()
                return jsonify({"message": "User has been deleted!!", "user_id": user_id})
            else:
                return jsonify({"message": "User name or password is invalid"})

    except Exception as err:
        return jsonify({"message": "Missing key {}".format(err)})
    return jsonify({"message": f"User not found"})


if __name__ == '__main__':
    db.create_all()
    if os.environ.get('ADMIN_USER') and os.environ.get('ADMIN_PASSWORD'):
        if not User.query.filter_by(username=os.environ.get('ADMIN_USER')).first():
            hashed_password = generate_password_hash(os.environ.get('ADMIN_PASSWORD'), method='sha256')
            admin_user = User(username=os.environ.get('ADMIN_USER'), 
            firstname='Admin', 
            lastname='Adminov', 
            email='admin@admin.com', 
            password=hashed_password, 
            status='enabled', role='admin')
            db.session.add(admin_user)
            db.session.commit()
            logging.warning("Admin user has been created!!")
    app.run(port=5000, host='0.0.0.0')
