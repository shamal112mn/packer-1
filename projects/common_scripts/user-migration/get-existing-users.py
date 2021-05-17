import json
from app import User, db

with open('users.json') as file:
    data = json.load(output_users)


for item in data:
    user = User(firstname=item['firstname'],
    lastname=item['lastname'],
    password=item['password'],
    status='True',
    username=item['username'],
    role=item['role'],
    email=item['email'])
    try:
        db.session.add(user)
        db.session.commit()
    except:
        print('User has problem')
