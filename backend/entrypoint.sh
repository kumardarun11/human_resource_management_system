#!/bin/sh

echo "Starting Laravel..."

if [ ! -f ".env" ]; then
    cp .env.example .env
fi

php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear

php artisan storage:link || true

exec "$@"