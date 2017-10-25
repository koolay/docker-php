php fpm
------

xhgui + xhprof

## RUN

- fpm

```bash

docker run --name fpm -d --restart=always -p 9000 \
   -v <myproject>:/home/app/webapp \
   -e XHGUI_MONGODB_URI=172.17.0.1:27017 \
   -e XHGUI_RATE=50 \
   daocloud.io/koolay/fpm:latest


docker run --name fpm-xhgui -d --restart=always -p 9000 \
   -v <xhgui root>:/home/app/xhgui
   daocloud.io/koolay/fpm:latest
```

- nginx

```
docker run --name nginx -d --restart=always -p 80:80 --link fpm --link fmp-xhgui \
    -v nginx/nginx.conf:/etc/nginx/nginx.conf \
    -v nginx/webapp.conf:/etc/nginx/conf.d/default.conf \
    -v nginx/xhgui.conf:/etc/nginx/conf.d/xhgui.conf \
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


## xhprof + xhgui

**环境变量:** 

`XHGUI_MODE`

`XHGUI_MONGODB_URI`

`XHGUI_RATE`
