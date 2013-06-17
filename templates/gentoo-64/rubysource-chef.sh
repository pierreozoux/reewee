#!/bin/bash

source /etc/profile

libyaml_version="0.1.4"
ruby_version="1.9.3-p392"

wget -O- http://pyyaml.org/download/libyaml/yaml-$libyaml_version.tar.gz | tar oxz
cd yaml*
./configure --prefix=/usr/local
make && make install
cd ..
rm -rf *yaml*

wget -O- http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-$ruby_version.tar.gz | tar oxz
cd ruby*
./configure --prefix=/usr/local --enable-shared --disable-install-doc --with-opt-dir=/usr/local/lib
make && make install
cd ..
rm -rf *ruby-*

gem install chef --no-rdoc --no-ri
