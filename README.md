php fpm
------

## RUN

- fpm
```

docker run --name fpm -d --restart=always -p 9000 \
   -v <myproject>:/home/app/webapp \
   daocloud.io/koolay/php-fpm:5.6

```

- nginx

```
docker run --name nginx -d --restart=always -p 80:80 --link fpm \
    -v nginx/nginx.conf:/etc/nginx/nginx.conf \
    -v nginx/webapp.conf:/etc/nginx/conf.d/default.conf \
    -v <myproject>:/home/app/webapp \
     daocloud.io/library/nginx:1.10.0-alpine

```

## About config

- user

The image has an app user with UID 9999 and home directory /home/app. Your application is supposed to run as this user. Even though Docker itself provides some isolation from the host OS, running applications without root privileges is good security practice.
Your application should be placed inside /home/app.

- fpm

map your config files:  

> -v /etc/php/5.6/fpm/conf.d
> -v localLocation/conf:/etc/php/5.6/fpm

https://github.com/docker-library/php/blob/005bb88143b7c54a4f86818adca6e3214f406128/5.6/fpm/Dockerfile



