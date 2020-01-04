FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
    wget \
    aptitude \
    apt-utils \
    patch \
    gcc \
    pmake \
    build-essential \
    vim \
    mecab \
    libmecab-dev \
    mecab-ipadic-utf8 \
    curl \
    language-pack-ja

# bashのプラグイン導入
# スクリプトを別に用意して任意で導入できるようにする
# RUN curl -fsSL https://starship.rs/install.sh -y | bash
# RUN echo 'eval "$(starship init bash)"' >> ~/.bashrc

# シェルで日本語を表示する（localeの設定）
RUN echo 'export LANG=ja_JP.UTF-8' >> ~/.bashrc

# ユーザーディレクトリの作成．ここで作業を行う
RUN mkdir -p /home/user01

################
# Install geta #
################
# geta2の取得
WORKDIR /home/user01/
RUN wget http://geta.ex.nii.ac.jp/getaN2002/release/geta2_200102.tgz && \
    tar -zxvf geta2_200102.tgz
# GETAROOTの設定
ENV GETAROOT /usr/local/geta
RUN mkdir $GETAROOT
# patchファイルの準備
COPY ./src/ciconf.patch /home/user01/
# geta2のインストール
WORKDIR /home/user01/geta2/
RUN patch -p1 < ../ciconf.patch || RET=$? || true && \
    CFLAGS="-fPIC" ./configure --prefix=$GETAROOT --with-gmake && \
    mv testsuit/tst.c testsuit/tst.c.bak && \
    sed -e "s/varargs.h/stdarg.h/g" testsuit/tst.c.bak > testsuit/tst.c && \
    mv lib/srvmu/srvmu.h lib/srvmu/srvmu.h.bak && \
    sed -e "s/size_t strnlen/\/\/size_t strnlen/g" lib/srvmu/srvmu.h.bak > lib/srvmu/srvmu.h && \
    make && \
    make install
# getaのコマンドを使えるようにパス設定
ENV PATH $PATH:/usr/local/geta/sbin

# nkfのインストール
WORKDIR /home/user01/
RUN wget 'https://ja.osdn.net/frs/redir.php?m=jaist&f=nkf%2F64158%2Fnkf-2.1.4.tar.gz' -O nkf-2.1.4.tar.gz
RUN tar zxvf nkf-2.1.4.tar.gz
RUN cd nkf-2.1.4 && \
    make && make install

# mecab-perl-0.996のインストール
COPY ./src/mecab-perl-0.996.tar.gz /home/user01/
WORKDIR /home/user01/
RUN tar zxvf mecab-perl-0.996.tar.gz
RUN cd mecab-perl-0.996 && \
    perl Makefile.PL && \
    make && make install

# 日本語sampleを動作させるためのディレクトリ作成
RUN mkdir -p /home/user01/project/sample
WORKDIR /home/user01/project/sample
COPY ./src/sample/. ./
RUN mkdir -p ./wams/sample/
RUN touch ./wams/sample/freqfiles

# ファイルの整理
WORKDIR /home/user01/
RUN mkdir download
RUN mv geta2_200102.tgz ./download/
RUN mv mecab-perl-0.996.tar.gz ./download
RUN mv nkf-2.1.4.tar.gz ./download

