import requests
import os
import argparse
from github import Github

## organization name and token on env
organization = 'fuchicorp'



token = os.environ.get("GIT_TOKEN")

## Reading all members from file 
## with open('github-management/manage-users/users-to-add.txt') as file:
##    users = file.read().splitlines()
users = os.environ.get('GITHUB_USERNAME').splitlines()

## Getting github user and organization 
g = Github(token, base_url='https://api.github.com')
org = g.get_organization(organization)


## Getting all teams 
teams = org.get_teams()

## Function takes list and gettes users and returns as list 
def get_users(users):
    
    ## Empty list which will be returned 
    result = []
    for user in users:
        try:
            ## Trying to get user and append to result
            result.append(g.get_user(user))
        except:
            print(f"User not found <{user}>")
    return result

## Users class using script to be able to get github users 
user_clases = get_users(users)

## Lopping to each teams 
for team in teams:

    ## If team is part of members
    if team.name.lower() == "members":

        ## looping to users class to be able to onboard to memebers team 
        for user in user_clases:
            try:
                ## Trying to invite user to organization 
                org.invite_user(user=user, teams=[team])
                print(f"User <{user.login}> has been invited to join Fuchicorp <{team.name}>")
            except:
                print(f"User <{user.login}> is already part of <{team.name}>")
