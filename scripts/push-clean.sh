#!/bin/bash
# Get token and push
export $(grep GITHUB_TOKEN /root/.hermes/profiles/wickedyoda/.env)
git remote add origin "https://x-access-token:$GITHUB_TOKEN@github.com/wickedyoda/OnceHuman_GameServer.git" 2>&1 || git remote set-url origin "https://x-access-token:$GITHUB_TOKEN@github.com/wickedyoda/OnceHuman_GameServer.git"
git push -f origin HEAD:main 2>&1