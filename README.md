# build-geta-env
dockerでgeta2が動作する環境を構築．

## 環境構築
```bash
$ git clone https://github.com/kenchalros/build-geta-env.git
$ cd build-geta-env

# geta-envイメージの作成
$ docker build ./ -t geta-env-image
# イメージからコンテナの作成
$ docker create --name geta-env -it geta-env-image /bin/bash
```

### コンテナ起動 & bashでログイン
```
$ docker start geta-env
$ docker exec -it geta-env /bin/bash
```

### コンテナ停止
```
$ docker stop geta-env
```
