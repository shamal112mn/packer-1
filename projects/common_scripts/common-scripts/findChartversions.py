#! python3

import os, sys, json, requests
from distutils.version import StrictVersion

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'


chart_name = str(sys.argv[2])
repository_name = str(sys.argv[1])
package_name = str(sys.argv[2])
# gets current version of chart
current_version = os.popen("helm ls | grep "  + chart_name + " |awk '{print $9}'")
current_version = current_version.read()
current_version = current_version.split('-')

if len(current_version) > 2:
    current_version = os.popen("helm ls | grep " + chart_name +   " |awk '{print $9}' | cut -f3 -d '-'")
elif len(current_version) == 2:
    current_version = os.popen("helm ls | grep " + chart_name +   " |awk '{print $9}' | cut -f2 -d '-'")

current_version = current_version.read()
url = "https://artifacthub.io/api/v1/packages/helm/" + repository_name + "/" + package_name + "/" + str(current_version)
url = url.strip()
# makes API call to the url
req = requests.get(url)   

# getting available versions from data retrived from api call. and sorts only versions that are higher than current version.
def get_available_versions():
    data = json.loads(req.text)
    available_versions = data ['available_versions']
    for existing_versions in available_versions:
        final_version = existing_versions ['version']
        if StrictVersion(final_version) > StrictVersion(current_version):
            print(final_version)  # ?? how to print them in numeric order
        # else StrictVersion(current_version) == StrictVersion(final_version):   # if current chart version is equal to lates available version, this condition should executed. ??? how to compare latest version
        #     print ("You are using latest version of the chart.")


print(bcolors.OKGREEN + "Your current " + str(chart_name) + " version is " + str(current_version) + bcolors.ENDC)
print(bcolors.HEADER + "Following the list of available versions to upgrade your chart: " + bcolors.ENDC)
get_available_versions()
# print("Recommended version to upgrate: " + str(recommended_version))     ## is there a way to find out what is next supported version to upgrade.
print(bcolors.OKBLUE + "for Documentation visit following url:" + bcolors.ENDC + " https://artifacthub.io/packages/helm/" + repository_name + "/" + package_name )


