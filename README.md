![](/app/assets/images/logo_100.png)

[![CircleCI](https://circleci.com/gh/marcomd/insiemento.svg?style=shield)](https://circleci.com/gh/marcomd/insiemento)
[![License](https://img.shields.io/github/license/RubyMoney/money.svg)](https://opensource.org/licenses/MIT)

# Insiemento

The name is a mix of italian words: Insieme (togheter) - Momento (moment)

## What is it?

Insiemento is a management application for gyms and fitness centers.
It provides a desktop graphical interface for administrators, a modern and responsive graphical interface
for users.

The first milestone has been reached: the management of fitness courses and the basic structure to allow
users to register and book courses.

The second milestone is almost completed: add multitenant management to host multiple organizations on the
same platform.
Each can have a dedicated instance which selects the ID via ENV.
Alternatively, they can be hosted on the same instance, selected via subdomain.

The third milestone is in progress: it concerns customer subscriptions and the management of products that each
organization will be able to configure. User must have a valid subscription in order to partecipate to courses.

## How does it work

Allows root administrators to manage via UI:

- Organizations
- Diagnostics
- System logs

Allows administrators of each organization to configure:

- Courses
- Trainers
- Rooms where the courses will be phisically done
- Define the program of the week: course, trainer, room, day and time
- Categories and products (to manage subscriptions)

_In progress_: users can buy products to extend their subscriptions. They create orders with choosen products, 
then pay and gain access. The goal is to create a simple ecommerce to allow users to independently extend their subscription.

An automatism:

- Every week creates the events defined in the program

Users:

- Sign up with the web app
- They choose the courses they wish to participate in (Now each user can attendee only if he own a valid subscription)
- They go to the gym

Each course has its parameters:

- From when it is possible to book, from when to cancel etc.

### Subscriptions

The administrator defines the category, for each one creates one or more products. Codes are generated for each product
that the customer buys to extend the validity of his subscription.

For example:

- Fitness category
  - Product: 30 days price 30€
    - Subscription Code 642b26d9fb1c00
    - Subscription Code 68b15041537759
    - ...
  - Product: 1 year price 300€
    - Subscription Code 7a588db36df631
    - ...
- Aquagym category
  - Product: x days price x€
    - Subscription Code ...

When a customer redeems a code, he actually extends the validity of his account.

It is possible to have multiple valid subscriptions covering different categories.
To participate in a course, the customer must have an active subscription (not expired) and of the same category
of the course. In this way, it is possible to define multiple types of products that can be purchased separately.

Currently, only administrators can associate a subscription with a customer but it will be automated in the future.

### Things we may want to cover:

- [x] A backend with ui for admin users
- [x] A mobile responsive front end in VueJS for users
- [x] A login/sign up with confirmation and reset password, sent by sendgrid
- [x] Milestone1: Management of fitness training sessions (course events)
- [x] Milestone2: Organizations for multitenant management `v0.5.0`
- [x] Products management
- [x] Milestone3: Customers subscription management `v0.6.0`
- [ ] Milestone4: Orders and payments management, in progress `v0.12.0`
- [ ] Milestone5: Organizations fee management


## Docker

The application is ready to be run in a docker container.

We use environment variables as [good practice](https://12factor.net/config) says.

In the database.yml file we have such references:

```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  database: <%= ENV['POSTGRES_DB'] %>
  username: <%= ENV['POSTGRES_USER'] %>
  password: <%= ENV['POSTGRES_PASSWORD'] %>
  port: <%= ENV['POSTGRES_PORT'] || '5432' %>
  host: <%= ENV['DATABASE_HOST'] %>

development:
  <<: *default

test:
  <<: *default

production:
  <<: *default
```

The name of the `POSTGRES_XXX` variables is not random, they are also used by the postgres image to initialize the instance.

Now we create the `.env` file in the application root with the environment variables inside.

The `database` and `redis` value are references to containers defined in the `docker-compose.yml` file.
 

```
DATABASE_HOST=database

POSTGRES_DB=insiemento_d
POSTGRES_USER=my_db_user
POSTGRES_PASSWORD=my_db_password

REDIS_HOST=redis
```

We are ready to create containers:

```
$ docker-compose up -d
``` 

You should see this output

```
Creating otpservice_database_1 ... done
Creating otpservice_redis_1    ... done
Creating otpservice_app_1      ... done
Creating otpservice_sidekiq_1  ... done
Creating otpservice_rspec_1    ... done
```

the web app is listen on port 3100

```
$ docker-compose ps

        Name                       Command               State            Ports
----------------------------------------------------------------------------------------
otpservice_app_1        entrypoint.sh bundle exec  ...   Up       0.0.0.0:3100->3100/tcp
otpservice_console_1    entrypoint.sh bundle exec  ...   Up
otpservice_database_1   docker-entrypoint.sh postgres    Up       5432/tcp
otpservice_redis_1      docker-entrypoint.sh redis ...   Up       6379/tcp
otpservice_sidekiq_1    entrypoint.sh bundle exec  ...   Up
otpservice_rspec_1      entrypoint.sh bundle exec  ...   Up
```

Remember to stop postgres and redis locally if present

```
# On mac
brew services stop redis
brew services stop postgres

# On linux
sudo systemctl stop redis
sudo systemctl stop postgres
```