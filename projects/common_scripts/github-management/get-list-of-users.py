import requests
import os
import json

organization = "fuchicorp"
token = os.environ.get("GIT_TOKEN")


def find_team_id(team_name):
    teams_url= f"https://api.github.com/orgs/{organization}/teams"
    resp = requests.get(url=teams_url, headers={"Authorization": f"token {token}"})
    if resp.status_code == 200:
        for team in resp.json():
            if team['name'].lower() == team_name.lower():
                return team['id']
        else:
            return None

def is_user_member(username):
    team_id  = find_team_id("academy-students")
    if team_id is not None:
        team_url = f"https://api.github.com/teams/{team_id}/members"
        resp = requests.get(url=team_url, headers={"Authorization": f"token {token}"})
        if resp.status_code == 200:
            for user in resp.json():
                if user['login'].lower() == username.lower():
                    return True
            else:
                return False


if __name__ == '__main__':
    print(find_team_id("academy-students"))
    if is_user_member("beamsoul"):
        print("Yes this use is in the system")
    else:
        print("This user is not in the list")