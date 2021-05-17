#!/usr/bin/env python
# coding: utf-8

# # Task 1
# Write a function call printRespos
# 1. Function should do api call link
# 2. Find parsed repos 
# 3. Print all matched repos 
# 

# In[16]:


import requests 

def printRespos(reponame):
    url = 'https://nexus.fuchicorp.com/service/rest/v1/components?repository=webplatform'
    data = requests.get(url).json()
    for repo in data['items']:
        if reponame in  repo['name']:
            print('docker.fuchicorp.com/' + repo['name'] + ':' + repo['version']  )


# In[17]:


printRespos('prod')


# In[ ]:




