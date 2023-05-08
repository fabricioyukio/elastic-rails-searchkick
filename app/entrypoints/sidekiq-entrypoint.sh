#!/bin/sh

set -e

service cron start

exec "$@"
# bundle exec sidekiq