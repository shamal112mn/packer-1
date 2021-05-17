#!/usr/bin/env bash

if [[ "$GIT_TOKEN" ]]; then
  {
    # Get list of members from dev teams
    curl -X GET \
    https://api.github.com/teams/3091662/members \
    -H 'Accept: application/vnd.github.v3+json' \
    -H "Authorization: token $GIT_TOKEN" \
    -H 'Connection: keep-alive' \
    -H 'Host: api.github.com' | jq '[.[].login]'
  } || {
    echo "The token for git hub not found 'GIT_TOKEN'."
  }
fi
