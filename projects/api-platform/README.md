# What is API? 

Application Programing Interface (API) is communication language for softwares.  If you will develop some kind of big applications you will have to create your own API and Documentation how to use it. API is useful tool when you are working integration of multiple Softwares. 

Methods
1. GET         Get information from server 
2. POST       Post your information or object 
3. PUT          Update your data from  
4. DELETE   Delete your information or object

We will be focus on `requests` library on python. You will need to login to your pynote and install `requests` library.  After you installed the library you will need to run following code
```
import requests
response = requests.get('https://qa.api.academy.fuchicorp.com/')
if response.status_code == 200:
	print(response.json()['message'])
```

If you see the message `Welcome to FuchiCorp API` that means everything was success. 

## Get method or get list of users
URL 'https://api.academy.fuchicorp.com/v0.1/example/users'
if you will use GET method for this url you should get  list of users which is exist on system. You will use this method after you have created user.

#### Example python code
```
import requests
url =  'https://api.academy.fuchicorp.com/v0.1/example/users'
response = requests.get(url)
if response.status_code == 200:
		print(response.json())
else:
		print('Something went wrong')
```




## Post information or post user 
url  'https://api.academy.fuchicorp.com/v0.1/create_example/user'
We will use post method to create our user. 

Keys:
1. username: Required
2. password: Required
3. email: Required
4. firstname: Required
5. lastname: Required

##### Python example code 
```
import requests
url = 'https://api.academy.fuchicorp.com/v0.1/create_example/user'
user = {"username": "fsadykov", "password": "redhat", "firstname": "Farkhod", "lastname": "Sadykov", "email": "example@gmail.com"}
response = requests.post(url, json=user)
if response.status_code == 200:
    print(response.json()['message'])
else:
    print('Something went wrong')
```

If you see `User has been created!!` that means user has been created successfully.



## Put method or Update our existing data on server
url  'https://api.academy.fuchicorp.com/v0.1/update_example/user/'
This page requires existing users uuid you should be able use previous method to get your information GET.  This page also requires username and password to update existing user.  After you give right information you should get response that user have been updated

Keys:
1. uuid: Required
2. username: Required
3. password: Required
4. email: optional
5. firstname: optional
6. lastname: optional

#### Example Python code
```
import requests
url =  'https://api.academy.fuchicorp.com/v0.1/example/users'

## Get exising users UUID
response = requests.get(url)
if response.status_code == 200:
    for user in response.json():
        if 'fsadykov' == user['username']:
            user_id = user['UUID']
else:
    print('Something went wrong')

## Update username from Farkhod Sadykov to Frank Smith
update_url = f'https://api.academy.fuchicorp.com/v0.1/update_example/user/{user_id}'
updated_user = {
    'username': 'fsadykov',
    'password': 'redhat',
    'firstname': 'Frank',
    'lastname': 'Smith',
    'email': 'smith@fuchicorp.com'
}

response = requests.put(update_url, json=updated_user)
if response.status_code == 200:
    print(response.json())
else:
    print('Something went wrong')
```


if you see the message `User information has been updated!!` that means everything went well.

## Delete method or Delete our existing data on server
With `DELETE` method you should be able to delete existing user from api server.  For example in this case we will delete user `fsadykov` from server.


Keys:
1. uuid: Required
2. username: Required
3. password: Required

### Example python code 
```
import requests
url =  'https://api.academy.fuchicorp.com/v0.1/example/users'

## Get exising users UUID
response = requests.get(url)
if response.status_code == 200:
    for user in response.json():
        if 'fsadykov' == user['username']:
            user_id = user['UUID']
else:
    print('Something went wrong')

## Delete user from system 
delete_url = f'https://api.academy.fuchicorp.com/v0.1/delete_example/user/{user_id}'
updated_user = {
    'username': 'fsadykov',
    'password': 'redhat'
}
response = requests.delete(delete_url, json=updated_user)
if response.status_code == 200:
    print(response.json())
else:
    print('Something went wrong')
```

200 response should be `User has been deleted!!` and you should see also user_id. 