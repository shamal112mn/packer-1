import os
import stashy
import json

stash_url = os.environ.get('STASH_URL')
username  = os.environ.get('STASH_ADMIN_USER')
password  = os.environ.get('STASH_ADMIN_PASSWORD')

if username and password and stash_url:
    stash = stashy.connect(f"{stash_url}", username, password)
else:
    print('PLease configure <STASH_URL>, <STASH_ADMIN_USER>, <STASH_ADMIN_PASSWORD>')



with open('groups.json', 'w') as file:
    json.dump(stash.admin.groups.list(), file, indent=2)

# with open('restaurantpollingworker.json', 'w') as file:
#     json.dump(stash.admin.users.list(), file, indent=2)

with open('projects.json', 'w') as file:
    json.dump(stash.projects.list(), file, indent=2)
