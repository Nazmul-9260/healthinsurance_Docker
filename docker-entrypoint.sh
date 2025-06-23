#!/bin/sh

# 
set -e

# PostgreSQL create check
echo "Waiting for PostgreSQL database connection..."
until nc -z -v -w30 db 5432; do
  echo "Waiting for database..."
  sleep 5
done
echo "Database is up!"

# .env copy
if [ ! -f ".env" ]; then
    echo "Creating .env file from .env.example..."
    cp .env.example .env
fi

# APP_KEY না থাকলে generate করবে
if ! grep -q "APP_KEY=base64" .env; then
    echo "Generating application key..."
    php artisan key:generate
fi

# migrate run
echo "Running migrations..."
php artisan migrate --force

# storage/cache permission
chown -R www-data:www-data storage bootstrap/cache
chmod -R 775 storage bootstrap/cache

# container main process
exec "$@"

