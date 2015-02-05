#!/bin/bash
# Deploy script to heroku
LOCAL_SUBNET=120.0

currentBranch() {
  git branch | grep "*" | sed "s/* //"
}

safeMatchingEnvForBranch() {
  case $1 in
    "dev") env="rbdev";;
    "nna") env="rbnna";;
    #"master") env="heroku";;
    *) echo "none"
       exit ;;
  esac
  echo "$env"
}

chez_local() {
  ifconfig  | grep inet | grep "$LOCAL_SUBNET"
}


case $1 in
  "rbnna") branch="nna"
           heroku_app="$1";;
  "rbdev") branch="dev"
           heroku_app="$1";;
  "risebox") branch="master"
          heroku_app="heroku";;
  "") branch=$(currentBranch)
      heroku_app=$(safeMatchingEnvForBranch $(currentBranch))
      if [ "$heroku_app" = "none" ]; then
        echo "No matching env found"
        echo "Choose 'rbnna', 'rbdev' or 'risebox' !"
        exit
      fi
      echo "No target env specified: safely deploying to $heroku_app";;
  *) echo "Choose 'rbnna', 'rbdev' or 'risebox' !"
     exit ;;
esac

echo "-- Pushing $branch to $heroku_app"
git checkout $branch

# if [ "$?" = "0" ] && [ -n "$(chez_local)" ]; then
#   echo "-- Pushing to CI"
#   git push origin $branch
# fi

if [ "$?" = "0" ]; then
  echo "-- Pushing to GitHub"
  git push origin $branch

  if [ "$?" = "0" ]; then
    echo "-- Pushing to Heroku"
    git push $heroku_app $branch:master
  fi
fi