# Introduction

This is a test project to automate the deployment of a rails application.

# Environments

We have two environments

* Development: in which everything will be inside docker containers (rails applications, 
  database, webpacker, etc)
* Production: in which only the rails application will be inside a container.

## Setting up the development environment

You need a [working installation](https://docs.docker.com/install/) of docker running in your machine.

Once you have docker up and running, the following steps will get you a development environment of the project in your machine.

Clone the repository:

```bash
> git clone https://github.com/p91-challenge/p91-challenge.git 
``` 

We will cache gems, node_modules, packs and other stuff of the rails application
inside local docker volumes. We will warm up those cached volumes now before spinning up the containers:

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

## Setting up the production environment

For this challenge I will setup a production environment using Digital Ocean. Since 
I'm supposed to simulate a production environment, I wanted to use a cloud provider to do it.
Digital Ocean is the cloud provider I'm more confortablem with so thats why I've chosen it.

If you want to deploy the environment you will need to create a Digital Ocean account and have
a few bucks available to spin up some droplets. 

### Install Vagrant

Follow the documentation and [install vagrant](https://www.vagrantup.com/docs/installation/) in your machine. I had a 
MacBook Pro with brew installed so I just did:

```bash
> brew install vagrant
```

The version of Vagrant I used at the time of writing was 2.2.7.

### Install Vagrant plugins

#### Vagrant digital ocean plugin

Nothing worth mentioning here, just [follow the documentation](https://github.com/devopsgroup-io/vagrant-digitalocean):

```bash
> vagrant plugin install vagrant-digitalocean
Installing the 'vagrant-digitalocean' plugin. This can take a few minutes...
Fetching: multipart-post-2.1.1.gem (100%)
Fetching: faraday-1.0.1.gem (100%)
Fetching: vagrant-digitalocean-0.9.5.gem (100%)
Installed the plugin 'vagrant-digitalocean (0.9.5)'!
```
 
Note: If you get an error due to a SSL certificate problem, have a look at [this section of the README](https://github.com/devopsgroup-io/vagrant-digitalocean#user-content-troubleshooting).

#### hostmanager plugin

```
> vagrant plugin install vagrant-hostmanager
```

We will use this plugin to set the `/etc/hosts` file of the droplets.

(see To Do section below for more info)

### Create a Digital Ocean token

Just follow the [Digital Ocean documentation](https://www.digitalocean.com/docs/apis-clis/api/create-personal-access-token/) 
and create a token.

### Create and upload a private key to Digital Ocean

Create a [private key](https://www.digitalocean.com/docs/droplets/how-to/add-ssh-keys/create-with-openssh/)
and upload it to [Digital Ocean](https://www.digitalocean.com/docs/droplets/how-to/add-ssh-keys/to-account/).

### Start the droplets

You need to set up three environment variables that are used in the
Vagrantfile:

* `DO_TOKEN`: the Digital Token you created before
* `DO_SSH_KEY_NAME`: the name of the Digital Ocean ssh key you created before
* `DO_SSH_KEY_PATH`: the path to the key in your local machine (`~/.ssh/id_rsa`) by default 

```bash
> DO_TOKEN=... DO_SSH_KEY_NAME=... vagrant up
Bringing machine 'db-droplet' up with 'digital_ocean' provider...
Bringing machine 'core-droplet' up with 'digital_ocean' provider...
Bringing machine 'jenkins-droplet' up with 'digital_ocean' provider...
==> core-droplet: Using existing SSH key: la de siempre
==> db-droplet: Using existing SSH key: la de siempre
==> jenkins-droplet: Using existing SSH key: la de siempre
==> db-droplet: Creating a new droplet...
==> jenkins-droplet: Creating a new droplet...
==> core-droplet: Creating a new droplet...
==> db-droplet: Assigned IP address: 134.209.206.225
==> db-droplet: Private IP address: 10.110.0.4
==> core-droplet: Assigned IP address: 188.166.17.84
==> core-droplet: Private IP address: 10.110.0.2
==> jenkins-droplet: Assigned IP address: 188.166.17.134
==> jenkins-droplet: Private IP address: 10.110.0.3
```

This command may take some time because it will also provision the drooplets. You can find
the provision shell scripts in the directory `vagrant_scripts`.

After the droplets are up and running, we run the `vagrant-hostmanager` plugin
to set the `/etc/hosts` file in all the droplets:

```bash
> vagrant hostmanager --provider=digital_ocean
```

### Finish the installation of jenkins

After provisioning the `jenkins-droplet` you will get a message like
the following:

```bash
jenkins-droplet: ####################################
jenkins-droplet: Waiting for jenkins installation password...
jenkins-droplet: The jenkins installation password id:
jenkins-droplet: 5cf146f8fd4742939b909f375bde52cd
jenkins-droplet: Go to http://188.166.18.109:8080 to finish the instalacion of jenkins
jenkins-droplet: ####################################
```

Open the URL and follow the instructions to finish the installation of Jenkins.

Once installed, create a new Task of type `Pipeline`. I will name this task `p91-challenge` and refer to it
using this name in this document.

Set up the following options:
* Build Triggers: `GitHub hook trigger for GITScm polling`
* Pipeline: Use `Pipeline script fom SCM` for the definition ot the pipeline 
  and select git as SCM. Use the URL for this repository.


### Add a Github webhook

Add a github webhook using the following payload url: http://[jenkins-droplet public IP]:8080/github-webhook/

### Tooling

* __Containers__: I've chosen Docker as the container technology. Both because I'm familiar with it
  and it's the de facto standard nowadays. I could have used podman, from RedHat since this is a very simple
  project, but I decided to stick with the most known technology
* __Container orchestration__: I choose to deploy the containers using docker-compose in the production environment.
  Other options are Docker Swarm or Kubernetes. Since this is a very simple project, I choose to use the easiest tool to do the job
* __Container Registry__: This is the place were we store docker images. I choose to use the public
  docker registry (hub.docker.com). In a more realistic scenario, I've would have chosen
  the [container registry of GCP](https://cloud.google.com/container-registry))
* __CI/CD__: I choose Jenkins as the CI/CD server and used pipelines as the tool
  to automate the workflows
* __Infrastructure__: I choose to use Digital Ocean. Why Digital Ocean instead of Amazon, Google Cloud or Azure? Because it's the 
  one I've used in previous projects and given the time constraints I decided to work
  with a tool I'm familiar with. I also had the option of using local virtual machines with Virtual Box
  but I discarded it for several reasons:
  * I wanted to integrate Jenkins with Github, which is easier if you have everything deployed in the cloud 
  * Digital ocean allows me to give you access to the infrastructure I was using in case you requested it 
  * I wanted to use a cloud provider since your project is deployed in the cloud 
* __Provisioninig__: I used Vagrant to create the droplets and shell scripts to provision the virtual machines. The 
  configuration is also set using those shell scripts. Again, I choose not to use ansible for the sake of simplicity.
  For provisioning I've used:
  * Vagrant plugin to spin up droplets in Digital Ocean
  * Vagrant plugin to set the `/etc/hosts` files in each droplet (I could not make work with the private IPs of the droplets
    so this part requires some thinking and testing)
  * Vagrant SyncFolders to provision configuration files to the droplets 

# TO DO

Since I had a limited amount of time to perform this challenge, I had to make decissions
about what to do and, more importantly, what not to do. In this section I explain
why I made those decissions and write down things I had to skip in order to save some time.  

- [ ] Improve documentation of the development environment in this readme
- [ ] Add troubleshooting section for the development environment: a person who knows little about docker will have a hard time
  setting up the development environment if she gets any error
- [ ] Provide an alternative to set up de production environment in your local machine using Virtual Box
- [ ] Provide full instructions about how to install vagrant
- [ ] At the moment, the plugin `vagrant-hostmanager` is setting up the public ip addresses instead of the private ones.
  I can either replace this vagrant plugin with a better solution for node discovery (DNS service?)
  or investigate if the plugin allows to use the private IP's.
- [ ] Use ansible instead of shell scripts to provision the droplets 
- [ ] Add firewalls to the deployed droplets 
- [ ] Properly store secrets for the production environment
  
    
