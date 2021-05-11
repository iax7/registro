# Registro

[![Ruby][ruby-badge]][ruby-url]
[![Rails][rails-badge]][rails-url]
[![PostgreSQL][psql-badge]][psql-url]
[![NodeJS][node-badge]][node-url]

This webapp was developed using the following tools, those are not required but
can be a good baseline to start working in this project

- OS: [Fedora](https://getfedora.org/) `32`
- [rvm](https://rvm.io/)
- [nvm](https://github.com/nvm-sh/nvm)

## Run Locally

### Ubuntu 18.04 LTS Prerequisites

```bash
sudo apt-get install -y ruby build-essential patch ruby-dev zlib1g-dev liblzma-dev
sudo apt-get install -y libpq-dev #PostgreSQL
```

### Fedora 32 Prerequisites

```bash
sudo dnf install -y ruby ruby-devel gcc openssl-devel zlib-devel rpm-build libpq-devel g++
sudo dnf group install -y "C Development Tools and Libraries"
```

1. Ensure you have **Ruby** and **NodeJS** installed.
1. Install bundler gem: `sudo gem install bundler`
1. Install all gem dependencies: `bundle install`
1. Edit the **secrets** variables

   - If you are starting over:

     ```bash
     # 1. create .env file
     cp .env.template .env
     # 2. create a key
     rake secret | tail -1 | cut -c1-32 > config/master.key
     ```

   - Then create a **Credentials** file using
     `rails credentials:edit` and add the following content:

     ```yaml
     secret_key_base: xxxxxxxx

     google_key: xxxxxxxx
     api_user: xxxxxxxx
     api_pass: xxxxxxxx

     smtp:
       address: xxxxxx.xx.com
       domain: xxxxxxxxxx.com
       user_name: xxxx@xxxxxxxx.com
       password: xxxxxxxx
     ```

1. Start **PostgreSQL** DB (with docker)

   ```bash
   docker run --name reg -p 5432:5432 \
          -v ~/dev/data/reg:/var/lib/postgresql/data \
          -e POSTGRES_PASSWORD=123456 -d postgres:13
   ```

   1. Initialize the db:

   ```bash
   rails db:create
   rails db:schema:load
  
   rails db:seed

   # Optional - If you want to generate random data
   rails db:populate
   ```

1. Install yarn dependencies:

   ```bash
   yarn install --check-files
   ```

1. You should be ready to go. Run the project.

   ```bash
   rails server
   ```

1. You can login using admin account that was previously seed:
   > admin@domain.com / changeme

## Test

This project used RSPEC to run test. Set your environment first:

```bash
rails db:migrate RAILS_ENV=test
```

Run tests using: `rspec`

## Run in Heroku

For more information please visit the official [heroku page](https://devcenter.heroku.com/articles/getting-started-with-rails6)

- Set the Buildpacks:

  ```bash
  heroku buildpacks:clear
  heroku buildpacks:set heroku/nodejs
  heroku buildpacks:add heroku/ruby
  ```

- Set environmental Variables (for PROD):

  ```bash
  heroku config:set RAILS_MAX_THREADS=1
  heroku config:set RAILS_MIN_THREADS=1
  heroku config:set RAILS_ENV=production
  heroku config:set RAILS_MASTER_KEY=$(cat config/master.key)
  heroku config:set RAILS_SERVE_STATIC_FILES=true
  ```

- Create the DB

  ```bash
  heroku rake db:schema:load
  heroku rake db:seed
  ```

- You will have an administrator account already configured.
  Login using the following credentials: `admin@domain.com:changeme`

### Maintenance

Update Gems

```bash
bundle update
```

## Documentation

- [Database](docs/db.md)
- [Security Map](docs/security.md)

<!-- Links -->
[ruby-badge]: https://img.shields.io/badge/ruby-3.0.1-blue?style=flat&logo=ruby&logoColor=CC342D&labelColor=white
[ruby-url]: https://www.ruby-lang.org/en/
[rails-badge]: https://img.shields.io/badge/rails-6.1-blue?style=flat&logo=ruby-on-rails&logoColor=CC0000&labelColor=white
[rails-url]: https://rubyonrails.org/
[psql-badge]: https://img.shields.io/badge/PostgreSQL-13.0-blue?style=flat&logo=postgresql&logoColor=336791&labelColor=white
[psql-url]: https://www.postgresql.org/download/
[node-badge]: https://img.shields.io/badge/NodeJS-12-blue?style=flat&logo=node.js&logoColor=339933&labelColor=white
[node-url]: https://nodejs.org/en/
