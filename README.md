# Introduction

This is a test project to automate the deployment of a rails application.

# Environments

We have two environments

* Development: in which everything will be inside docker containers (rails applications, 
  database, webpacker, etc)
* Production: in which only the rails application will be inside a container.

## Configuration of the development environment:

The following steps will get you a development environment of the project in your machine.

Clone the repository:

```bash
> git clone https://github.com/p91-challenge/p91-challenge.git 
``` 

We will cache gems, node_modules, packs and other stuff of the rails application
inside local docker volumes. We will warm up those cached volumes now:

```bash
> docker-compose run --rm runner bundle
> docker-compose run --rm runner yarn install
```

Once everything is ready, startup the rails application:

```bash
> docker-compose up rails webpacker
Creating network "p91-challenge_default" with the default driver
Creating p91-challenge_db_1 ... done
Creating p91-challenge_webpacker_1 ... done
Creating p91-challenge_rails_1     ... done
Attaching to p91-challenge_webpacker_1, p91-challenge_rails_1
rails_1      | => Booting Puma
rails_1      | => Rails 6.0.2.2 application starting in development
rails_1      | => Run `rails server --help` for more startup options
webpacker_1  | ℹ ｢wds｣: Project is running at http://localhost:3035/
webpacker_1  | ℹ ｢wds｣: webpack output is served from /packs/
webpacker_1  | ℹ ｢wds｣: Content not from webpack is served from /app/public/packs
webpacker_1  | ℹ ｢wds｣: 404s will fallback to /index.html
webpacker_1  | ℹ ｢wdm｣: Hash: e6098af6eed778c3ae34
webpacker_1  | Version: webpack 4.42.1
webpacker_1  | Time: 1112ms
webpacker_1  | Built at: 03/30/2020 7:43:09 PM
webpacker_1  |                                      Asset       Size       Chunks                         Chunk Names
webpacker_1  |     js/application-d20cc56e278f3a3acfa2.js    506 KiB  application  [emitted] [immutable]  application
webpacker_1  | js/application-d20cc56e278f3a3acfa2.js.map    571 KiB  application  [emitted] [dev]        application
webpacker_1  |                              manifest.json  364 bytes               [emitted]
webpacker_1  | ℹ ｢wdm｣: Compiled successfully.
rails_1      | Puma starting in single mode...
rails_1      | * Version 4.3.3 (ruby 2.6.5-p114), codename: Mysterious Traveller
rails_1      | * Min threads: 5, max threads: 5
rails_1      | * Environment: development
rails_1      | * Listening on tcp://0.0.0.0:3000
rails_1      | Use Ctrl-C to stop
``` 

Open up a web browser and point it to `localhost:3000`. You should see the rails
application up and running.

# TO DO

- [ ] Improve documentation of the development environment
- [ ] Add troubleshooting section for the development environment