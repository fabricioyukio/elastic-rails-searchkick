#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

cp /usr/src/app/Procfile.dev /usr/src/app/Procfile


bundle exec rails dartsass:build
bundle exec rails assets:precompile

# bundle exec rails s -p 3000
# exec bundle exec "$@"
bundle exec rails server -b 0.0.0.0
# bundle exec foreman start -f Procfile