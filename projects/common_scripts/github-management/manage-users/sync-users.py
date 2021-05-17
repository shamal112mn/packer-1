import requests
import os
import argparse
from github import Github

## Organization name and token on env
organization = 'fuchicorp'
token = os.environ.get("GIT_ADMIN_TOKEN")


## Getting github user 
g = Github(token, base_url='https://api.github.com')

## Getting organization 
org = g.get_organization(organization)

## Getting all members of organization 
users = [ user for user in org.get_members()]

## Looping to each team in organization 
for team in org.get_teams():

    ## If team name is members 
    if 'members' == team.name.lower():

        ## Looping to all memebers 
        for user in users:

            ## Adding people to members team
            team.add_to_members(user)
            print(f"User <{user}> added to members")
        