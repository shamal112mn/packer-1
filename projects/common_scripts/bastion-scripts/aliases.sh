# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions


alias k='kubectl'
alias kd='kubectl describe'
alias kgp='kubectl get pod'
alias runningjobs='kubectl get pod -n tools -o yaml | grep -i jenkinsjoblabel'