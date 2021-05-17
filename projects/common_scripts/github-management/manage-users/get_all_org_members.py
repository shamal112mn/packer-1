from github import Github
import os
import json
import logging
import sys

logging.basicConfig()
logging.getLogger().setLevel(logging.INFO)

organization_name = "fuchicorp"

## Getting github and organization 
g = Github(os.environ.get("GIT_TOKEN"))
organization = g.get_organization(organization_name)

## Getting all members of organization 
users = [ user.login for user in organization.get_members()]

## Saving into organization-members.json file 
with open("organization-members.json", 'w') as file:
    json.dump(users, file, indent=2)