from flask import render_template, Flask, jsonify
from jinja2 import Template
from github import Github
import flask
import os
import yaml
import requests

app = Flask(__name__)

if os.environ.get('GIT_TOKEN'):
    print("Found github token using <GIT_TOKEN> env")
    token = os.environ.get("GIT_TOKEN")
    organization = 'fuchicorp'
    g = Github(token, base_url='https://api.github.com')
    org = g.get_organization(organization)
else:
    print("Can not find github token!!")
    exit()

def isItUp(url):
    if app.debug:
        return True
    
    try:
        response = requests.get(url)
    except Exception as e:
        print(e)
        return False
    if response.status_code == 200 or response.status_code == 403:
        return True
    else:
        return False 

@app.route('/re-sync')
def re_sync():
    with open('configurations/user-information.yaml', 'w') as file:
        config_data = {
            "data" : []
        } 
        for user in org.get_members():
            config_data['data'].append(user.raw_data)
        yaml.dump(config_data, file)
    return jsonify({"message": "Successful"})

@app.route('/')
def index():
    # data =  requests.get('https://raw.githubusercontent.com/fuchicorp/isitup/master/configurations/domains.yaml').text
    with open('configurations/user-information.yaml') as file:
        user_info = yaml.load(file)
        
    return render_template('index.html', config_data=user_info)

@app.route('/services/<domain>')
def services(domain):
    with open('services-config.yaml') as file:
        file = file.read().format(domain=domain)
        services = yaml.load(file)
        for service in services['data']:
            if isItUp(service['url']):
                service['status'] = True
                service['message'] = "The application is up and running!!" 
            else:
                service['status'] = False
                service['message'] = "The application is down!!" 

    return render_template('services.html', config_data=services)

## /info page to get all environment variables for users 
@app.route('/info')
def info():
    return jsonify(
        {
            "environment": os.environ.get('ENVIRONMENT'),
            "instance" :  os.environ.get('INSTANCE'),
            "release" :  os.environ.get('RELEASE'),
            "logging-mode": app.debug
        } )

@app.route('/meeting')
def meeting():
    with open('configurations/domains.yaml') as file:
        config = yaml.load(file)
        
    return render_template('meeting.html', config_data=config)

if __name__ == '__main__':
    if os.environ.get('DEBUG') and 'true' == os.environ.get('DEBUG').lower():
        debug = bool(os.environ.get('DEBUG').capitalize())
    else:
        debug = False
    
    app.run(host='0.0.0.0', debug=debug)