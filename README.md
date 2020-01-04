# build-geta-env
geta2を動かすための環境をDockerで構築する．

## setting
```bash
$ git clone https://github.com/kenchalros/build-geta-env.git
$ cd build-geta-env

# create docker image of geta-env
$ docker build ./ -t geta-env-image
# create docker container from docker image
$ docker create --name geta-env -it geta-env-image /bin/bash
```

### start container & bash login
```
$ docker start geta-env
$ docker exec -it geta-env /bin/bash
```

### stop container
```
$ docker stop geta-env
```
