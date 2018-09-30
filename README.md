# DockerServer
This is an easy to use nginx server designed to handle multiple domains as docker services. 

Now I am concerned what you heard is 

> This is an nginx server designed to handle multiple domains as docker services.

but what I said was 

>This is an ***easy to use*** nginx server designed to handle multiple domains as docker services.

It is seriously so easy that I hope you wore brown pants, because you are about to be sh!tting them.

It uses 
[jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy "nginx-proxy") and the Let's Encrypt companion application
[JrCs/docker-letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion "letsencrypt-nginx-proxy-companion").
To make setting up a multi domain server with ssl easy as hell.

## Requirements
* A server (Tested with Ubuntu 16.04 and 18.04)
* git
* [Docker](https://www.docker.com/ "Docker")
* [docker-compose](https://docs.docker.com/compose/install/ "Install Docker Compose")
* That is it. No seriously, that is it.

## Usage

### First Run
Obviously, clone this repo where you want it. 

On first run, you need to setup the `nginx-proxy` network. Do this by running the following command. You only need to do this once.
```bash
docker network create nginx-proxy
```

Now you need to start the reverse proxy. In a terminal, cd into the `nginx-proxy` folder and run
```bash
docker-compose up -d
```

The nginx proxy server is now running. You don't need to do this ever again. It is done and you are completly setup and ready
to go. That is all. No configuration needed. It autoconfigures.

### Setup Website
A complete example for running a wordpress website is located in `websites/example.com`. You should be able to figure it out from
there but here are some tips. 

* The folder name doesnt matter, but naming it `yourdomain.tdl` is a good naming convention. Hell, it doesnt even need to be in this
folder, just on the same computer. But I like structure.
* You don't need to do anything with the ports command. The nginx-proxy server handles all of that for you and keeps your port from being exposed.
* You don't need to setup ssl or any nginx config, it happens ***automagically***

##### Important

You must use the `nginx-proxy` network we setup in ***First Run*** on all sites. Add it to the bottom of your
`docker-compose.yml` file like this.
```yaml
networks:
  default:
    external:
      name: nginx-proxy
```

You have to set the enviroment variables to tell nginx-proxy how to setup your site
```yaml
services:
  service_name:
    environment:
      VIRTUAL_HOST: example.com # the incomming domain name for this site
      VIRTUAL_PORT: 80 # the port your application exposes
      LETSENCRYPT_HOST: example.com # the domain name to issue cert to, same as VIRTUAL_HOST
      LETSENCRYPT_EMAIL: youremail@example.com # this email can be any of your emails. Not domain specific
```

You need to expose your port to the network so it can be autorouted. You can expose the same port as many times as you want.
For instance, you can have 20 sites that expose port 80. It doesn't matter, it will autoroute. It must be the same port
set in the `VIRTUAL_PORT` enviroment variable.
```yaml
services:
  service_name:
    expose:
    - 80 # the port your application exposes
```

If you want your site to auto reboot on crash and auto startup, be sure to add a restart policy.
```yaml
services:
  service_name:
    restart: unless-stopped
    # OR not AND
    # restart: always
```

### Activate websites
To activate your sites, first point your domain to your server, then cd into the folder with it's `docker-compose.yml` file and run
```bash
docker-compose up -d
```
**nginx-proxy** will detect it on the network, set it up, issue an ssl cert, autorenew its certs, and activate it.

To stop the service, cd into the folder and run.
```bash
docker-compose down
```
The service will stop and **nginx-proxy** will detect this and remove it's service.


## Development
I'm a developer and I assume you are as well since you are here. I need a dev environment close to
my production environment. So for your dev machine, you can do almost an identical setup but with a 
`.local` or, my preference, a `.dev` domain name. Just use the `nginx-proxy-dev` container instead of
the `nginx-proxy` one. Still do the initial network setup, and make a separate website folder with a
`.dev` extension instead of `.com` or whatever tdl you are using.

There are two scripts in the root of this project named `devdomain.sh` and `devdomain-mac.sh`.
Unfortunately, Mac uses a different version of grep, so on a mac, use that one. This 
script allows you to add your custom domains to the host file easily.

To add:
```bash
sh devdomain.sh add yourdomain.dev
```

To remove
```bash
sh devdomain.sh remove yourdomain.dev
```

Now when you go to `yourdomain.dev` on your computer your host file will route you to `nginx-proxy-dev` and it will
pick it up and route you to your site.

For windows, the setup is a little harder. You need to download a decent development operating
system like Ubuntu and install it. Be sure to completely overwrite your windows installation
as you shouldn't be using it ever again. I am serious. If you are developing anything other than
windows desktop applications, you need to get the hell off windows. Docker sucks on it. Or more accurately,
It sucks at running docker and everything else. 

### Logs
To see what the hell is going on, cd into the `nginx-proxy` folder and run
```bash
docker-compose logs
```
If you want to watch the logs, run.
```bash
docker-compose logs -f
```
Simple


### Pull requests
Yeah, go for it. Make it better, submit pull request. 

### Questions and comments

Any questions, you can just post them in the issues section. Until github builds in a decent
discussion platform there is not a good other option. I don't see why people get bent out of shape
when people do this. It is the only way to ask questions on github currently and everyone
 can search the issues to see them.