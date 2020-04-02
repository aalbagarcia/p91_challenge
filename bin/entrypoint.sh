#!/bin/bash
set -e

if [ "$1" = 'rails' ]; then
  rails db:migrate
fi

exec "$@"