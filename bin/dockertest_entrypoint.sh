#!/bin/bash
set -e

if [ "$1" = 'rails' ]; then
  RAILS_ENV=test rails db:drop
  RAILS_ENV=test rails db:create
  RAILS_ENV=test rails db:schema:load
fi

exec "$@"