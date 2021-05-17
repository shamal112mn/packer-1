import argparse
import os
from github import Github



## organization name and token on env
organization = 'fuchicorp'
token = os.environ.get("GIT_TOKEN")

if not os.environ.get('GITHUB_USERNAME'):
    print('Please create environment variable <GITHUB_USERNAME> with list of users')
    exit(1)

users = os.environ.get('GITHUB_USERNAME').splitlines()

## Getting github user and organization 
g = Github(token, base_url='https://api.github.com')
org = g.get_organization(organization)



parser = argparse.ArgumentParser(description='Script to manage Fuchicorp Github Organization. Please follow the option to delete or invite poeple')

parser.add_argument('--invite', const=True, default=False, nargs='?',
                    help='Inviting github users to FuchiCorp organization.')

parser.add_argument('--delete', const=True, default=False, nargs='?',
                    help='Deleting github users to FuchiCorp organization.')

parser.add_argument('--addUserTeam', const=True, default=False, nargs='?',
                    help='Add existing user to FuchiCorp Organization Team.')

parser.add_argument('--removeUserTeam', const=True, default=False, nargs='?',
                    help='Add existing user to FuchiCorp Organization Team.')
args = parser.parse_args()


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


if args.invite:
    ## Users class using script to be able to get github users 
    user_clases = get_users(users)
    ## Getting all teams 
    teams = org.get_teams()
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
                    print("Please ask Members to accept the invitation from Fuchicorp on Github")
                except:
                    print(f"User <{user.login}> is already part of <{team.name}>")

elif args.delete:
    ## looping to users to delete 
    for user in users:
        ## Trying to get the user 
        try:
            
            user = g.get_user(user)
            ## Deleted user from organization 
            org.remove_from_members(user)
            print(f"User <{user}> has been successfully deleted from Fuchicorp on Github")

        except Exception as error:
            print(f"User <{user}> {error}")
            print(f"User <{user}> is not a member of Fuchicorp")



elif args.addUserTeam:
    ## Check the user if user exist in the organization
    ## Check the team from the organization
    ## Then onboard user to orgnzations team
    if os.environ.get('ORG_TEAM_NAME'):
        for user in users:
            user = g.get_user(user)
            team_name = os.environ.get('ORG_TEAM_NAME')
            teams = org.get_teams()
            for team in teams:
                if team.name == team_name:
                    team.add_membership(user)
                    print(f"The {user.name} was added to the team {team.name}!!")
    else:
        print("Error: Missing environment variable <ORG_TEAM_NAME>")


elif args.removeUserTeam:
    ## Check the user if user exist in the organization
    ## Check the team from the organization
    ## Then offboard user from the organization
    if os.environ.get('ORG_TEAM_NAME'):
        for user in users:
            user = g.get_user(user)
            team_name = os.environ.get('ORG_TEAM_NAME')
            teams = org.get_teams()
            for team in teams:
                if team.name == team_name:
                    team.remove_membership(user)
                    print(f"The {user.name} was removed from the team {team.name}!!")
    else:
        print("Error: Missing environment variable <ORG_TEAM_NAME>")


