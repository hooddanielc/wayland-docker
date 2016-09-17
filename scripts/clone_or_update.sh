set -e
repo=$1
dest=$(basename $repo)

cd ${WLROOT}
if [ $? != 0 ]; then
  echo "Error: Could not cd to ${WLROOT}.  Does it exist?"
      exit 1
fi
echo
echo $dest
if [ ! -d ${dest} ]; then
  git clone ${repo} ${dest}
  if [ $? != 0 ]; then
    echo "Error: Could not clone repository"
    exit 1
  fi
fi
cd ${dest}
git checkout master
if [ $? != 0 ]; then
  echo "Error: Problem checking out master"
  exit 1
fi
git pull
if [ $? != 0 ]; then
  echo "Error: Could not pull from upstream"
  exit 1
fi
cd ${WLROOT}
