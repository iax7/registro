# registro

## Introduction
WebApp to manage people registration to an event, that includes food consumption, 
transportation services, donations and payments.

![welcome_page](/github/welcome_page.png) 

This is my first rails app, there is a lot room for improvement, 
but I share it as a starting point for someone that has the same needs.

## Installation

### Local

To run locally you need to have a postgres database available. You can use docker
to have one really quick, you just need to run

```bash
docker run --name regdb -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres
```

Generate a development and test keys

```bash
key=$(rake secret); sed -i "s/#secret_key_base/$key/g" config/secrets.yml
``` 

Run the following commands:
```bash
bundle install
rails server
```

### Heroku
This app is heroku ready, you just need to clone this repository and run
the following commands:

```bash
heroku apps:create app_name
heroku buildpacks:set heroku/ruby
heroku addons:create heroku-postgresql
git push heroku master
heroku run rake db:schema:load RAILS_ENV=production
heroku run rake db:seed RAILS_ENV=production
```

You will need to create environment variables in your heroku account,
some of these are automatically created, just double check:

![DB Url](/github/vars.png)

* `LANG` is mandatory, this value is the only one available and is actually spanish (my bad).
* `MAX_THREADS` = 1
* `MIN_THREADS` = 1
* `PORT` = 80
* `RACK_ENV` = production
* `RAILS_ENV` = production
* `RAILS_SERVE_STATIC_FILES` = enabled
* `SMTP_PASS`, `SMTP_USER` is required if you want mail functionality
* `TZ` use the time zone that you desire
* `SECRET_GOOGLE_KEY` (optional, for google maps api)
    
## Configuration
You would want to modify the app configuration variables, these are located
in **config/app_config.yml**, the most important to start are the date variables.
These triggers validations that hides or disables functionality, the best is to set
them some time in the future.
```yaml
registration_starts:   '2017-08-20 00:00:00' #(String) Date when the "register" button is enabled
registration_deadline: '2017-11-10 00:00:00' #(String) Allows new registrations until this
food_deadline:         '2017-11-10 00:00:00' #(String) Allows food changes until this
allocation_deadline:   '2017-11-10 00:00:00' #(String) Allows lodging changes until this
transport_deadline:    '2017-11-10 00:00:00' #(String) Allows transportation changes until this
event_ends:            '2017-11-20 14:00:00' #(String) Allows full app functionality until this
adult_age:             11     #(integer) Age to charge full price
event_full_price:      100    #(integer) Inscription fee
food_full_price:       60     #(integer) Amount money to charge for food
food_half_price:       30
allocation_full_price: 100    #(integer) Amount money to charge for lodging
allocation_half_price: 50
transport_full_price:  10     #(integer) Amount money to charge for transportation
max_allocation_men:    125    #(integer) Max amount of Men capacity to allocate
max_allocation_women:  125    #(integer) Max amount of Women capacity to allocate
max_food:              500    #(integer) Max people capacity to serve food
max_people:            1200   #(integer) Max people capacity to attend the event
api_user:              'user' #(string) API user name
api_pass:              'pass' #(string) API password
paycollectors: []  # (Array) People information that are allowed to charge the amount to paid
```

## Quick References
### Restore a Backup
```bash
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U 'postgres' -d 'postgres' backup.dump
```

## To Do

* The project has no tests at all. This is very dangerous as the project gets bigger.
* The app UI is in spanish even when the language is set in en-US.
* Several UI messages are in the html file, this needs to be decoupled in Rails language files.

## Contribute

You are welcome to contribute in this project, I found these [Instructions](https://gist.github.com/MarcDiethelm/7303312) 
very helpful.
