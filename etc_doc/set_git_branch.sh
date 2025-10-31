client_branch_file="/var/share/CLIENT_BRANCH.txt"
app_branch_file="/var/share/APP_BRANCH.txt"

if [ -f "$app_branch_file" ]; then
  APP_BRANCH=$(head -n 1 "$app_branch_file" | tr -d '[:space:]')
else
  echo "master" > "$app_branch_file"
  APP_BRANCH="master"
fi


if [ -f "$client_branch_file" ]; then
  CLIENT_BRANCH=$(head -n 1 "$client_branch_file" | tr -d '[:space:]')
else
  echo "master" > "$client_branch_file"
  CLIENT_BRANCH="master"
fi

export CLIENT_BRANCH=${CLIENT_BRANCH:-"master"}
export APP_BRANCH=${APP_BRANCH:-"dev"}