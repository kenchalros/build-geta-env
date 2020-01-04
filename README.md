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

## 仮想環境を使う
### start container & bash login
```
$ docker start geta-env
$ docker exec -it geta-env /bin/bash
```

### stop container
```
$ docker stop geta-env
```

## サンプルの動かし方
```
$ cd /home/user01/project/sample
# 頻度ファイルを作成
$ perl mkfreq.pl > wams/sample/freqfile
# 文字コードを変更
$ nkf -j --overwrite wams/sample/freqfile
# wamファイルの作成
$ mkw sample wams/sample/freqfile ci.conf
# ここまでで準備は完了．あとは適当に動かしてみる．
$ perl search.pl -q hoge
```

## appendix
### bashのプラグイン導入
bashの見た目をいい感じにしてくれる
```
$ curl -fsSL https://starship.rs/install.sh | bash
$ echo 'eval "$(starship init bash)"' >> ~/.bashrc
```