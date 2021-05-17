#!/usr/bin/env bash

TEAM_ID="3146212"
for USER in $(cat "github-management/manage-users/users-to-add.txt"); do
  curl --user "fsadykov:${GIT_ADMIN_TOKEN}" -X PUT -d "" "https://api.github.com/teams/members/memberships/${USER}"
done
