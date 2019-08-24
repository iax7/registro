# README

This webapp was developed using the following tools, those are not required but
can be a good baseline to start working in this project

* OS: `Fedora 30`
* Ruby `2.6.3`
* Rails `6`
* Postgres Docker Image `postgres:11.5`

## Run Locally
### Ubuntu 18.04 LTS Prerequisites
```bash
sudo apt-get install -y ruby build-essential patch ruby-dev zlib1g-dev liblzma-dev
sudo apt-get install -y libpq-dev #PostgreSQL
```

### Fedora 30 Prerequisites
```bash
sudo dnf install -y ruby ruby-devel gcc openssl-devel zlib-devel rpm-build libpq-devel g++
sudo dnf group install -y "C Development Tools and Libraries"
```

1. Ensure you have **Ruby** and **NodeJS** installed.
1. Install bundler gem: `sudo gem install bundler`
1. Install all gem dependencies: `bundle install`
1. Edit the **secrets** variables 
    * If you are starting over, create a key:
      ```bash
      rake secret | tail -1 | cut -c1-32 > config/master.key
      ```
      
    * Then create a **Credentials** file using 
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
    docker run --name regdb -p 5432:5432 \
           -e POSTGRES_PASSWORD=123 -e POSTGRES_USER=reg -e POSTGRES_DB=reg \
           -v ~/dev/data/regdb:/var/lib/postgresql/data -d postgres:11.5
    ```
    * Intialize the db:
        ```bash
        rails db:migrate
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
1.  You can login using admin account that was previously seed:
    > admin@domain.com / changeme

## Test

This project used RSPEC to run test. Set your environment first:
```bash
docker run -it --rm -e PGPASSWORD=123 \
           --link regdb:postgres postgres:11.5 \
           createdb -h regdb -U reg --owner=reg reg_test

rails db:migrate RAILS_ENV=test
```
Run tests using: `rspec`

## Run in Heroku
For more information please visit the official [heroku page](https://devcenter.heroku.com/articles/getting-started-with-rails5#rake)
* Set environmental Variables (for PROD):
    ```bash
    heroku config:set RAILS_MAX_THREADS=1
    heroku config:set RAILS_MIN_THREADS=1
    heroku config:set RAILS_ENV=production
    heroku config:set RAILS_MASTER_KEY=$(cat config/master.key)
    heroku config:set RAILS_SERVE_STATIC_FILES=true
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
