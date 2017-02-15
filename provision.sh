#!/bin/sh

#AmazonLinuxでの処理
if cat /etc/system-release | grep "Amazon Linux" ; then

    echo "###########################"
    echo "AmazonLinuxの環境構築をします"
    echo "###########################"

    #PHP,httpdインストール
    sudo yum -y install php56 php56-devel php56-intl php56-mbstring php56-pdo php56-gd php56-mysqlnd

    #MySQLインストール
    sudo yum -y install mysql56-server

    #composerインストール
    curl -s https://getcomposer.org/installer | php

    #cakephpライブラリインストール
    cd ~/training/test_app/
    yes | ~/composer.phar install

    #aws.confにシンボリックリンクを貼る
    sudo ln -s /home/ec2-user/training/aws.conf /etc/httpd/conf.d/.

    #アパッチの再起動
    sudo service httpd restart

    #timezoneの変更(日本時間にする)
    sudo ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
    #AmazonLinuxの場合UTCに戻るためclockを変更。バックファイルを作成し、文字を置換し上書きする処理
    sudo sed -i".org" -e "s/=\"UTC\"/=\"Asia\/Tokyo\"/g" -e "s/=true/=false/g" /etc/sysconfig/clock
fi

#CentOSでの処理
if cat /etc/system-release | grep "CentOS" ; then

    echo "###########################"
    echo "CentOSの環境構築をします"
    echo "###########################"

    #httpdインストール
    yum -y install httpd

    #epel,remi インストール
    yum -y install epel-release
    rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

    #phpと必要なモジュールをインストール
    yum -y install --enablerepo=remi,epel,remi-php56 php php-devel php-intl php-mbstring php-pdo php-gd php-mysqlnd

    #MariaDBアンインストール
    yum -y remove mariadb-libs.x86_64

    #mysqlレポジトリ追加
    yum -y install http://dev.mysql.com/get/mysql57-community-release-el7-8.noarch.rpm

    #yum設定変更のためのパッケージのインストール
    yum -y install yum-utils

    #mysql5.7→mysql5.6
    yum-config-manager --disable mysql57-community
    yum-config-manager --enable mysql56-community

    #mysqlインストール
    yum -y install mysql-community-server

    #composerインストール
    cd /usr/local/bin
    curl -s https://getcomposer.org/installer | php

    #composerでcakephpライブラリをインストール
    cd /vagrant/test_app/
    yes | /usr/local/bin/composer.phar install

    #httpd設定シンボリックリンク作成
    ln -s /vagrant/cakephp.conf /etc/httpd/conf.d/.

    #httpd起動、自動起動設定
    systemctl start httpd
    systemctl enable httpd

    #mysql起動、自動起動設定
    systemctl start mysqld
    systemctl enable mysqld

    #DB作成
#    mysql -u root -e"
 ##   create database trump;
  #  grant all on trump.* to cakephp@localhost identified by 'cakephp';
  #  use trump
   # create table cardlogs (
   # id int unsigned auto_increment primary key,
   # date datetime,
   # num int,
   # result text);
   # "

fi
