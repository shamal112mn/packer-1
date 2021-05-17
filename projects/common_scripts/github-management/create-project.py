import requests
import os
import argparse

## organization name and token on env
organization = 'fuchicorp'
token = os.environ.get('GIT_TOKEN')

## All action arguments for this sctipt
parser = argparse.ArgumentParser(description="FuchiCorp Automation Scripts. Script will create project")
optional = parser._action_groups.pop()
required = parser.add_argument_group('required arguments')

## Adding arguments to required groups
required.add_argument('-u', '--username', help='Username for project', required=True)
parser.add_argument("-a", "--action", choices=["create", "delete"], required=True)
parser.add_argument("-d", "--description", help="Description for the project")


header = {"Authorization": f'token {token}', "Accept" : "application/vnd.github.inertia-preview+json"}


def create_org_project(username, organization, description=None):
    url = f'https://api.github.com/orgs/{organization}/projects'
    if description is not None:
        object = {
            "name": f'Project-{username}',
            "body": f'{description}'
        }
    else:
        object = { "name": f'Project-{username}', "body": 'FuchiCorp member project' }
    resp = requests.post(url=url, headers=header, json=object)
    if resp.status_code == 200:
        print(f'Project-{username} has been created')

args = parser.parse_args()

if __name__ == '__main__':
    if args.action == 'create' and args.description:
        create_org_project(args.username, organization, args.description)
    elif args.action == 'create':
        create_org_project(args.username, organization)
