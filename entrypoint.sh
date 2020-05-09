#!/bin/bash

# Tells the /bin/sh shell that runs the script to fail fast if there are any problems later in the script
set -e

echo "Hello $USER."
echo "Today is $(date)"
echo "Current working directory : $(pwd)"

# Remove a potentially pre-existing server.pid for Rails.
rm -f /insiemento/tmp/pids/server.pid

# Compile the assets
#bundle exec rake assets:precompile

bundle check || bundle install
yarn check || yarn install --check-files

bundle exec rails db:migrate

# Start the server
echo "$1 $2 $3 $4 $5 $6 $7 $8 $9"
$1 $2 $3 $4 $5 $6 $7 $8 $9