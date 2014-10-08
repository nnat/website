#!/bin/bash
# Deploy script to heroku
TERALIBRIS_SUBNET=120.0

currentBranch() {
  git branch | grep "*" | sed "s/* //"
}

safeMatchingEnvForBranch() {
  case $1 in
    "dev") env="rb-dev";;
    "nna") env="rb-nna";;
    #"master") env="heroku";;
    *) echo "none"
       exit ;;
  esac
  echo "$env"
}

chez_teralibris() {
  ifconfig  | grep inet | grep "$TERALIBRIS_SUBNET"
}


case $1 in
  "rb-nna") branch="nna"
            heroku_app="$1";;
  "rb-dev") branch="dev"
            heroku_app="$1";;
  "risebox") branch="master"
          heroku_app="heroku";;
  "") branch=$(currentBranch)
      heroku_app=$(safeMatchingEnvForBranch $(currentBranch))
      if [ "$heroku_app" = "none" ]; then
        echo "No matching env found"
        echo "Choose 'rb-nna', 'rb-dev' or 'risebox' !"
        exit
      fi
      echo "No target env specified: safely deploying to $heroku_app";;
  *) echo "Choose 'rb-nna', 'rb-dev' or 'risebox' !"
     exit ;;
esac

echo "-- Pushing $branch to $heroku_app"
git checkout $branch

# if [ "$?" = "0" ] && [ -n "$(chez_teralibris)" ]; then
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