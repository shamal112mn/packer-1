from flask import Flask, jsonify, request
from flask_sqlalchemy import SQLAlchemy
from flask_restplus import Resource, Api, fields
import os 

## App init instance
app = Flask(__name__)
# app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://username:password@localhost/db_name'

## Api init instance 
api = Api(app)

## DB init instance
db = SQLAlchemy(app)

## To be able to use following application you should provide DB creds
if not os.environ.get('MYSQL_USER') or not os.environ.get('MYSQL_PASSWORD') or not os.environ.get('MYSQL_HOST') or not os.environ.get('MYSQL_DATABASE'):
    print(f"You are missing environments <MYSQL_USER> <MYSQL_PASSWORD> <MYSQL_HOST> <MYSQL_DATABASE>")
    exit(1)
    
## Getting all configurations from `config.cfg`
app.config.from_pyfile('config.cfg')

## Function to return what ever not matching
def returnNotMatches(a, b):
    return [x for x in a if x not in b]

## User model which will contain some information
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True)
    email = db.Column(db.String(120), unique=True)
    first_name = db.Column(db.String(80))
    last_name = db.Column(db.String(80))
    password = db.Column(db.String(80))


    def __repr__(self):
        return '<User %r>' % self.username


resource_user = api.model('Resource', {
    'username': fields.String,
    'email': fields.String,
    'first_name': fields.String,
    'last_name': fields.String,
    'password': fields.String,
    
})    


## create user
@api.route('/users')
class UserManagement(Resource):
    def get(self):
        try:
            ## Trying to connect db and get all users to return as json 
            if not User.query.all():
                return jsonify({"message": "User not found"})
            else:
                ## Getting all users from db and making sure ready to return as json
                allUser = [ user.__dict__ for user in User.query.all()]
                for user in allUser:
                    user.pop('_sa_instance_state')
                return jsonify(allUser)
        except:
            ## Handeling the error making sure right message will be returned to user
            return jsonify({"message": "Can't connect to DB make."})


    @api.expect(resource_user, code=200)
    def post(self):
        try:
            json_data = request.json
            missingKeys = returnNotMatches( ['username', 'email', 'first_name', 'last_name', 'password'], json_data.keys())
            if missingKeys:
                return { "message": "Your are missing following keys", "items": missingKeys}

            ## Making sure user is not creating user again
            if User.query.filter_by(username=json_data['username']).first():
                return jsonify({"message": f"User <{json_data['username']}> already exist"})

            ## Making sure user is not creating user again with same email 
            if User.query.filter_by(email=json_data['email']).first():
                return jsonify({"message": f"Email <{json_data['email']}> already used!!"})

            try:
                ## Creating the user to data base
                new_user = User(username=json_data['username'], email=json_data['email'], first_name=json_data['first_name'], last_name=json_data['last_name'], password=json_data['password'])
                db.session.add(new_user)
                db.session.commit()
                return {"message" : f"User <{json_data['username']}> has been created!!"}
            except:
                return {"message": "Something wrong with creating user!!!"}
        except:
            return {"message" : "something went wrong!!"}

## Running the application
if __name__ == '__main__':
    db.create_all()
    app.run(debug=True, port=5000, host='0.0.0.0')