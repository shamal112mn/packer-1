import os
import yaml

i=0
file_list=[] #list of config files
c_path =  os.path.expanduser('kube-config-files/') #path to config files
path = os.path.expanduser('~/.kube/') #folder for combined "config" file
config_path = path + "config" #full path to combined "config" file

if os.path.isfile(config_path) == True:
    print ("'config' file already exist")
    ask_val= input("Do you really want to override 'config' file?(yes/no):")
else:
    ask_val= input("Do you want to create 'config' file?(yes/no):")

for root, dirs, files in os.walk(c_path):
    for filename in files:
        file_list.append(filename)
        file_name=c_path+file_list[i] #current config file + path
        i=i+1

        if ask_val == "yes" :
            with open(file_name) as file:
                 data = yaml.load(file, Loader=yaml.FullLoader)
            with open(config_path, 'w') as file:
                yaml.dump(data, file)
            a = '"config" file created/overridden successful'
        elif ask_val == "no" :
            with open(file_name) as file:
                 data = yaml.load(file, Loader=yaml.FullLoader)
            with open('kube_config', 'w') as file:
                yaml.dump(data, file)
            a = '"kube_config" file created'
        else:
            a = 'Wrong value. Type "yes" or "no"'
print(a)
