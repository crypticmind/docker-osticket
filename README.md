
# docker-osticket

Docker image with osTicket running on nginx

### Build

```
$ cd /path/to/docker-osticket
$ docker build --rm --tag=crypticmind:osticket .
```

### Setup

(this assumes you have your database already up and running)

Create a directory to hold configuration files (currently, only `ost-config.php` file), and copy the stub configuration file.

```
$ mkdir -p /path/to/config
$ cp /path/to/docker-osticket/fs/var/www/html/include/ost-sampleconfig.php /path/to/config/ost-config.php
```

Start the container in temporary setup mode. **This is only required the first time to create and populate database tables**.

```
$ docker run crypticmind:osticket \
    --name osticket --detach \
    --publish 8080:8080 \
    --env OSTICKET_SETUP=yes \
    --volume /path/to/config:/config 
```

Now go to `http://localhost:8080` and follow the setup process. Once completed, stop and remove the running container.

```
$ docker stop osticket && docker rm osticket
```

Now start again the container in production mode and you're done. **This is how you normally run an already configured instance**.

```
$ docker run crypticmind:osticket \
    --name osticket --detach \
    --publish 8080:8080 \
    --env OSTICKET_SETUP=no \
    --volume /path/to/config:/config 
```

### Versions

* Base image is Phusion's [baseimage](https://github.com/phusion/baseimage-docker) 0.9.19 providing Ubuntu 16.04.
* PHP Version 7.0.8-0ubuntu0.16.04.1 using FPM/FastCGI.
* Nginx 1.10.0
* osTicket development version (see notes).

No particular versions were specified for PHP and nginx. Those are the current versions provided by Ubuntu.

### Notes

This uses osTicket right from the development branch, following their ["bleeding edge installation"](https://github.com/osTicket/osTicket#deployment) mode.

The setup mode verifies that `ost-config.php` is writable. The production mode removes osTicket's `setup` directory.

Interesting log files include `/var/log/php7.0-fpm.log` and `/var/log/nginx/osticket-*.log`.

osTicket can be upgraded in two ways:

* Get into the container and update files there -- I don't recommend this.
* Follow the ["update"](https://github.com/osTicket/osTicket#deployment) process to update osTicket sources in `/path/to/docker-osticket/fs/var/www/html` and rebuild the container.

### License

This work is licensed under [MIT](https://opensource.org/licenses/MIT)

### Feedback

Feedback and contributions to the project, no matter what kind, are always very welcome.
