import requests
import os
import json
import logging 
from github import Github

owner = os.environ.get("GIT_ORG")
token = os.environ.get("GIT_TOKEN")

with open('github-management/manage-labels/labels.json') as file:
    labels = json.load(file)

g = Github(token)
org = g.get_organization('fuchicorp')
repos = org.get_repos()

for repo in repos:
    for label in labels:

        try:
            remote_label = repo.get_label(label['name'])
            if str(remote_label.name) != label['name'] or str(remote_label.description) != label['description']:
                remote_label.edit(label['name'], label['color'], label['description'])
                logging.warning(f'Updated label {remote_label.name} in {repo.name}')
            else:
                logging.warning(f'the label {remote_label.name} up to date in {repo.name}')
                
        except Exception as e:
            try:
                if 'minimum' in label.keys() and 'maximum' in label.keys():
                    for item in range(label['minimum'], label['maximum'] + 1):
                        repo.create_label(f"{label['name']} {item}", label['color'], label['description'])
                        logging.warning(f"{label['name']} {item} label has been created to {repo.name}")
                if 'minimum' not in label.keys() and 'maximum' not in label.keys():
                    repo.create_label(label['name'], label['color'], label['description'])
                    logging.warning(f"{label['name']} label has been created to {repo.name}")
            except Exception as e:
                logging.warning(f"Not able to creata label with error {e} {repo.name}")
