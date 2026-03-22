#!/bin/bash
# Usage: ./build.sh <repo_name> <tag>
REPO=$1
TAG=$2
docker build -t $REPO:$TAG .
