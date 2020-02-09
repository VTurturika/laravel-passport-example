# Laravel Passport Example

Simple example of usage Laravel Passport for API authentication

## Project setup

Project setup requires `docker` and `docker-compose`.

1. Clone project
```shell script
git clone https://github.com/VTurturika/laravel-passport-example.git && cd laravel-passport-example
```

2. Start docker containers
```shell script
docker-compose up -d
```

3. Prepare development database (mysql password is `root`)
```shell script
docker-compose exec database mysql -u root -p -e 'CREATE DATABASE passport_example;'
```

4. Set correct rights for project folders
```shell script
docker-compose exec web chmod 777 -R bootstrap/cache
docker-compose exec web chmod 777 -R storage
```

5. Go inside `web` container (all following commands should be executed inside container)
```shell script
docker-compose exec -u user web bash
```

6. Install composer dependencies
```shell script
composer install
```

7. Prepare correct `.env` file
```shell script
cp .env.example .env
php artisan key:generate
```

8. Set up credentials for database in `.env` file
```shell script
DB_HOST=database
DB_DATABASE=passport_example
DB_USERNAME=root
DB_PASSWORD=root
```

9. Run database migrations
```shell script
php artisan migrate
```

## Usage

First of all, initialize  `Laravel Passport` by following artisan command
```shell script
php artisan passport:install
```

Then create some users for testing
```shell script
curl --location --request POST 'http://localhost:8080/api/register' \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data-raw '{
      "name": "user1",
      "email": "user1@email.com",
      "password": "password",
      "password_confirmation": "password"
  }'
```

Try to get protected API resource (you should get `401` error)
```shell script
curl --location --request GET 'http://localhost:8080/api/user' \
  --header 'Accept: application/json'
```

Get `access` and `refresh` tokens with following request
```shell script
curl --location --request POST 'http://localhost:8080/oauth/token' \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data-raw '{
      "grant_type": "password",
      "client_id": "<password granted client_id from oauth_clients table>",
      "client_secret": "<password granted client_secret from oauth_clients table>",
      "username": "user1@email.com",
      "password": "password",
      "scope": ""
  }'
```

Now you can get protected API resource with next request
```shell script
curl --location --request GET 'http://localhost:8080/api/user' \
  --header 'Accept: application/json' \
  --header 'Authorization: Bearer <Access Token>'
```

Refresh tokens by following request
```shell script
curl --location --request POST 'http://localhost:8080/oauth/token' \
  --header 'Accept: application/json' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "grant_type": "refresh_token",
    "refresh_token": "<Refresh Token>",
    "client_id": "<password granted client_id from oauth_clients table>",
    "client_secret": "<password granted client_secret from oauth_clients table>",
    "scope": ""
  }'
```

More info in [official Laravel Passport docs](https://laravel.com/docs/6.x/passport).
