import requests
import os
import json
import logging 
import argparse
from github import Github

owner = os.environ.get("GIT_ORG")
token = os.environ.get("GIT_TOKEN")

with open('github-management/manage-labels/labels.json') as file:
    labels = json.load(file)

g = Github(token)
org = g.get_organization('fuchicorp')
repos = org.get_repos()


parser = argparse.ArgumentParser(description='Delete all labels which is maching <labels.json> file')
parser.add_argument('--delete', help='To delete all labels use --delete')

args = parser.parse_args()

if args.delete == 'yes':
    logging.warning("All labels are has been deleted !!")
    for repo in repos:
        remote_labels = repo.get_labels() 
        for remote_label in remote_labels:
            for label in labels:
                if label['name'] == remote_label.name:
                    remote_label.delete()
                    logging.warning(f"Deleted label {remote_label.name} from {repo.name}")
else:
    logging.error("Please use --delete yes")