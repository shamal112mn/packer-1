from app import db, User
import json
import argparse
import os

parser = argparse.ArgumentParser(description="FuchiCorp Academy Automation Scripts.")
optional = parser._action_groups.pop()
required = parser.add_argument_group('required arguments')

## Adding arguments to required groups
required.add_argument('-f', '--file', help='JSON file which will store list of users', required=True)

args = parser.parse_args()

if os.path.exists(f"{args.file}"):
    try:
        userdata = json.load(args.file)
        for user in userdata:
            try:
                new_user = User(username=user['username'],
                    firstname=user['user'],
                    lastname=user['lastname'],
                    password=user['password'],
                    email=user['email'],
                    role=user['role'],
                    status=user['status'])
                db.session.add(new_user)
                db.session.commit(new_user)
            except Exception as e:
                print(f"Error: {e}")
    except Exception as e:
        print(f"Error: {e}")
else:
    print("file does not exist")
