#!/bin/sh

echo "Starting Laravel..."

php artisan config:clear || true
php artisan cache:clear || true
php artisan route:clear || true
php artisan view:clear || true

php artisan storage:link || true

exec "$@"