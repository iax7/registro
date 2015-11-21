# reg

## Introduction
WebApp to manage people registration to an event, food consumption, 
transportation services, payments. 
Has a complementary Windows desktop app to control the arrivals and 
admission to food.

This is my first rails app, there is a lot room for improvement, 
but I share it as a starting point for someone that has the same needs.

## Installation

### Local

To run locally you need to have a postgres database available. You can use docker
to have one really quick, you just need to run

```sh
docker run --name regdb -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres
```

Then generate a development and test keys

```sh
key=$(rake secret); sed -i "s/#secret_key_base/$key/g" secrets.yml
``` 

Then run the following commands:
```sh
$ bundle install
$ rails server
```

### Heroku
This app is heroku ready, you just need to clone this repository and run
the following commands:

```sh
$ heroku apps:create app_name
$ heroku buildpacks:set heroku/ruby
$ heroku addons:create heroku-postgresql
$ git push heroku master
$ heroku run rake db:schema:load RAILS_ENV=production
$ heroku run rake db:seed RAILS_ENV=production
```

You will need to create environment variables in your heroku account,
some of these are automatically created, just double check:

![DB Url](/github/vars.png)

    * LANG is mandatory, this value is the only one available that is actually spanish (my bad).
    * MAX_THREADS (optional)
    * MIN_THREADS (optional)
    * PORT (mandatory)
    * RACK_ENV = production
    * RAILS_ENV = production
    * RAILS_SERVE_STATIC_FILES = enabled
    * SMTP_PASS, SMTP_USER is required if you want mail functionality
    * TZ use the time zone that you desire
    * SECRET_GOOGLE_KEY (optional, for google maps api)
    
## Configuration
You would want to modify the app configuration variables, these are located
in **config/application.rb**, the most important to start are the date variables.
These triggers validations that hides or disables functionality, the best is to set
them some time in the future.

    reg_adult_age = (integer) Age to charge full price
    reg_food_full_price = (integer) Amount money to charge for food
    reg_food_half_price = (integer) Amount money to charge for food
    reg_allocation_full_price = (integer) Amount money to charge for lodging
    reg_allocation_half_price = (integer) Amount money to charge for lodging
    reg_transport_full_price = (integer) Amount money to charge for transportation
    reg_max_allocation_men = (integer) Max Men capacity to allocate
    reg_max_allocation_women = (integer) Max Women capacity to allocate
    reg_max_food = (integer) Max people capacity to serve food
    reg_max_people = (integer) Max people capacity to attend the event
    reg_registration_deadline = (DateTime) Allows new registration until this
    reg_food_deadline = (DateTime) Allows changes in food until this
    reg_allocation_deadline = (DateTime) Allows changes in allocation until this
    reg_transport_deadline = (DateTime) Allows changes in transportation until this
    reg_event_ends = (DateTime) Allows full app functionality until this
    reg_paycollectors = (Array) People information that are allowed to charge the amount to paid
    dektop_app_url = (string) Public url where compiled desktop app is located
    api_user = (string) API user name
    api_pass = (string) API password
    
the **reg_paycollectors** is an array of this *specific* hash:

    {name: 'Person1', phone: '1111111111', email: 'known@email.com', location: 'Houston, TX', church: 'Known'}

## To Do

* The project has no tests at all. This is very dangerous as the project gets bigger.
* The app UI is in spanish even when the language is set in en-US.
* Several UI messages are in the html file, this needs to be decoupled in Rails language files.