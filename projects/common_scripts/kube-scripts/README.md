<h2>Instruction to combine script - 'combine_scr.py'</h2>

1. Configuration files should be in folder `'kube-config-files/'`
2. You must have Python3 installed to run the `'combine_scr.py'` script 
3. To run script - type:
```
python3 combine_scr.py
```
4. If the `'~/.kube/'`  file already exist, the script will ask you:
```
'config' file already exist
Do you really want to override 'config' file?(yes/no):
```
- `'yes'` - it will override the `'~/.kube/'` file; <p>
The script will notify you
```
"config" file created/overridden successful
```
- `'no'` - it will create `'kube_config'` file <p>
The script will notify you
```
"kube_config" file created
```
5. If the `'~/.kube/'`  file is not exist, the script will ask you:
```
Do you want to create 'config' file?(yes/no):
```
- `'yes'` - it will create the `'~/.kube/'` file; <p>
The script will notify you:
```
"config" file created/overridden successful
```
- `'no'` - it will create `'kube_config'` file; <p>
The script will notify you:
```
"kube_config" file created
```
6. If you input wrong value the script will notify you:
```
Wrong value. Type "yes" or "no"
```