# README

This webapp was developed using the following tools, those are not required but
can be a good baseline to start working in this project

* OS: `Fedora 28`
* Ruby `2.5.1p57`
* Postgres Docker Image `postgres:10.4`

## Run Locally
### Ubuntu 18.04 LTS Prerequisites
```bash
sudo apt-get install -y ruby build-essential patch ruby-dev zlib1g-dev liblzma-dev
sudo apt-get install -y libpq-dev #PostgreSQL
```
### Fedora 28 Prerequisites
```bash
sudo dnf install -y gcc ruby ruby-devel zlib-devel rpm-build libpq-devel
sudo dnf group install -y "C Development Tools and Libraries"
```

* Ensure you have **Ruby** and **NodeJS** installed.
* Install bundler gem: `sudo gem install bundler`
* Install all gem dependencies: `bundle install`
* Edit the secrets variables 
  * If you are starting over, create a configuration file
    using `rails credentials:edit` and add the following content
    (fill the `x`'s with your values):
    ```yaml
    secret_key_base: xxxxxxxx
    google_key: xxxxxxxx
    db_url: postgres://xxxxxxxx
    api_user: xxxxxxxx
    api_pass: xxxxxxxx

    smtp:
      address: xxxxxx.xx.com
      domain: xxxxxxxxxx.com
      user_name: xxxx@xxxxxxxx.com
      password: xxxxxxxx
    ```
  * If you have already a key create it in `/config´ folder
    ```bash
    echo '12345678900987654321' > config/master.key
    ```
* Start **postgresql** DB (with docker)
    ```bash
    docker run --name regdb -p 5432:5432 \
           -e POSTGRES_PASSWORD=123 -e POSTGRES_USER=reg -e POSTGRES_DB=reg \
           -v ~/data/regdb:/var/lib/postgresql/data -d postgres:10.4
    ```
* Intialize the db:
    ```bash
    rails db:migrate
    rails db:seed
    ```
* If you want to generate random data run: `rails db:populate`
* Run the project using `rails server`
* You can login using admin account that was previously seed:
    > admin@domain.com / changeme

### Create Test Database
```
docker run -it --rm -e PGPASSWORD=123 \
           --link regdb:postgres postgres:10.4 \
           createdb -h regdb -U reg --owner=postgres reg_test
rails db:migrate RAILS_ENV=test
```
Run tests using: `rails test`

## Run in Heroku
For more information please visit the official [heroku page](https://devcenter.heroku.com/articles/getting-started-with-rails5#rake)
* Set environmental Variables (for PROD):
    ```bash
    heroku config:set MAX_THREADS=1
    heroku config:set MIN_THREADS=1
    heroku config:set RACK_ENV=production
    heroku config:set RAILS_ENV=production
    heroku config:set RAILS_MASTER_KEY=xxxxxxxx
    ```
* Create the DB
    ```bash
    heroku rake db:schema:load
    heroku rake db:seed
    ```
* You will have an administrator account already configured.
  Login using the following credentials: `admin@domain.com:changeme`

### Issues
If the following error ocurrs while pushing your changes:
```
remote:        Downloading nokogiri-1.6.8.1 revealed dependencies not in the API or the
remote:        lockfile (mini_portile2 (~> 2.1.0)).
remote:        Either installing with `--full-index` or running `bundle update nokogiri` should
remote:        fix the problem.
```

Just run:
```bash
gem install nokogiri
bundle install
bundle update
```

### Maintenance
Update Gems
```bash
bundle update
bundle install
```

## Documentation

* [Database](docs/db.md)
* [Security Map](docs/security.md)
