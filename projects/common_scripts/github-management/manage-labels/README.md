# Working with organization common labels 
#FuchiCorp

Python scripts to manage labels in your GitHub orgnazition. We are using two scripts first is  `create-github-labels.py` which will create labels based on `labels.json` file. If you want to add more labels please go ahead open `labels.json` file and add more labels and re-run the `create-github-labels.py` script. You will need to be careful with delete script before you proceed with deletion make sure issues are not using it 

#### Versions
1. Python==3.7.4
2. PyGithub==1.47

To be able to create common labels for your organization you will following steps
```
git clone https://github.com/fuchicorp/common_scripts.git
```

After you have cloned the repo you will need to install required library with following command

```
pip install -r  github-management/manage-labels/requirements.txt
```

After packages are installed you will need to set two environment variables to authenticate GitHub 

```
export GIT_ORG='fuchicorp'
export GIT_TOKEN='your token'
```

If you set environment variables correctly you can go ahead with scripts. You will have two scripts first `create-github-labels.py` which will create all labels second `delete-github-labels.py` which  will delete all lables for you.

```
python github-management/manage-labels/sync-create-github-labels.py    
```


To delete all labels which is created by `create-github-labels.py` run the second script 

```
python github-management/manage-labels/delete-github-labels.py --delete yes
```

To delete all labels which is not inside `labels.json` file run following script 

/NOTE: This script will delete all labels which is not inside  `labels.json`/  

```
python github-management/manage-labels/delete-not-managed-labels.py --delete yes
```
