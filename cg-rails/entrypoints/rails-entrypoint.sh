#!/bin/sh

sudo set -e

if [ -f tmp/pids/server.pid ]; then
  sudo rm tmp/pids/server.pid
fi

# bundle exec rails s -p 3000
# exec bundle exec "$@"
bundle exec rails server -b 0.0.0.0