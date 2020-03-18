## hosts配置

`$ cat /etc/ansible/hosts`

    [webserver]
    node0[1:2]

    [webserver:vars]
    ansible_ssh_port=22
    ansible_ssh_user=root

    [nginx]
    node0[1:2]

    [webserver:children]
    apache
    nginx

    [mysql]
    node03
    node04

    [lnmp:children]
    webserver
    mysql

## 总目录结构

`$ tree .`

    .
    ├── lnmp.yml
    └── roles
        ├── mysql_install
        │   ├── files
        │   │   └── mysql-5.7.25-linux-glibc2.12-x86_64.tar.gz
        │   ├── tasks
        │   │   ├── copy.yml
        │   │   ├── install.yml
        │   │   ├── main.yaml
        │   │   └── prepare.yml
        │   ├── templates
        │   │   ├── change_passwd.sh
        │   │   ├── my.cnf
        │   │   └── mysqld.service
        │   └── vars
        │       └── main.yml
        ├── nginx_install
        │   ├── files
        │   │   └── nginx-1.15.0.tar.gz
        │   ├── tasks
        │   │   ├── copy.yml
        │   │   ├── install.yml
        │   │   └── main.yml
        │   ├── templates
        │   │   ├── fastcgi_params
        │   │   ├── nginx.conf
        │   │   ├── nginx.service
        │   │   └── server.conf
        │   └── vars
        │       └── main.yml
        └── php_install
            ├── files
            │   ├── libmcrypt-2.5.8.tar.gz
            │   └── php-7.2.6.tar.gz
            ├── handlers
            ├── meta
            ├── tasks
            │   ├── copy.yml
            │   ├── install.yml
            │   └── main.yml
            ├── templates
            │   └── php-fpm.conf
            └── vars
                └── main.yml


创建lnmp入口文件，用来调用roles：

`$ vim lnmp.yml`

    ---
    - hosts: dbserver
    remote_user: root
    gather_facts: True

    roles:
        - mysql_install

    - hosts: webserver
    remote_user: root
    gather_facts: True

    roles:
        - php_install
        - nginx_install


## mysql部分

### 创建mysql入口文件，用来调用mysql_install：

`$ vim mysql.yml` 

    # 用于批量安装MySQL
    ---
    - hosts: dbserver
    remote_user: root
    gather_facts: True

    roles:
        - mysql_install

### 创建变量：

`$ vim roles/mysql_install/vars/main.yml`

    #定义mysql安装中的变量
    MYSQL_VER: 5.7.25
    MYSQL_VER_MAIN: "{{ MYSQL_VER.split('.')[0] }}.{{ MYSQL_VER.split('.')[1] }}"

    DOWNLOAD_URL: https://mirrors.tuna.tsinghua.edu.cn/mysql/downloads/MySQL-{{ MYSQL_VER_MAIN }}/mysql-{{ MYSQL_VER }}-linux-glibc2.12-x86_64.tar.gz
    MYSQL_USER: mysql
    MYSQL_PORT: 3306
    MYSQL_PASSWD: 123456789
    SOURCE_DIR: /software
    BASE_DIR: /usr/local/mysql
    DATA_DIR: /data/mysql

### 创建模板文件：

#### mysql配置文件

`$ vim roles/mysql_install/templates/my.cnf`

    [client]
    port    = {{ MYSQL_PORT }}
    socket = {{ BASE_DIR }}/tmp/mysql.sock

    [mysql]
    default-character-set=utf8

    [mysqld]
    default-storage-engine=INNODB
    character_set_server=utf8
    explicit_defaults_for_timestamp
    basedir={{ BASE_DIR }}
    datadir={{ DATA_DIR }}
    socket={{ BASE_DIR }}/tmp/mysql.sock
    log_error = {{ BASE_DIR }}/log/error.log

    sql_mode=STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION

#### mysql服务文件

`$ vim roles/mysql_install/templates/mysqld.service`

    [Unit]
    Description=MySQL Server
    After=network.target
    After=syslog.target

    [Install]
    WantedBy=multi-user.target

    [Service]
    User=mysql
    Group=mysql
    ExecStart={{ BASE_DIR }}/bin/mysqld --defaults-file=/etc/my.cnf

    #连接数限制
    LimitNOFILE=65535
    LimitNPROC=65535

    #Restart配置可以在进程被kill掉之后，让systemctl产生新的进程，避免服务挂掉
    #Restart=always
    PrivateTmp=false

#### 更改数据库root密码脚本

`$ vim roles/mysql_install/templates/change_passwd.sh`

    #!/bin/bash
    #该脚本用于更改数据库root密码

    passwd={{ MYSQL_PASSWD }}
    n=`grep "{{ BASE_DIR }}/bin" /etc/profile | wc -l`

    if [ $n -eq 0 ]
    then
        echo "export PATH=$PATH:{{ BASE_DIR }}/bin" >> /etc/profile
        source /etc/profile
    else
        source /etc/profile
    fi

    {{ BASE_DIR }}/bin/mysql -uroot -D mysql -e "UPDATE user SET authentication_string=PASSWORD("$passwd") WHERE user='root';"

    {{ BASE_DIR }}/bin/mysql -uroot -e "FLUSH PRIVILEGES;"

    {{ BASE_DIR }}/bin/mysql -uroot -p$passwd -e "grant all privileges on *.* to root@'%'  identified by '$passwd';"

### 环境准备prepare.yml：

`$ vim roles/mysql_install/tasks/prepare.yml`

    - name: 关闭firewalld
      service: name=firewalld state=stopped enabled=no

    - name: 临时关闭 selinux
      shell: "setenforce 0"
      failed_when: false

    - name: 永久关闭 selinux
      lineinfile:
        dest: /etc/selinux/config
        regexp: "^SELINUX="
        line: "SELINUX=disabled"

    - name: 添加EPEL仓库
      yum: name=epel-release state=latest

    - name: 安装常用软件包
      yum:
        name:
          - vim
          - lrzsz
          - net-tools
          - wget
          - curl
          - bash-completion
          - rsync
          - gcc
          - unzip
          - git
          - perl-Data-Dumper
          - libaio-devel
          - autoconf
          - cmake
          - openssl
          - openssl-devel
          - pcre
          - pcre-devel
          - zlib
          - zlib-devel
          - gd-devel
          - libxml2-devel
          - bzip2-devel
          - gnutls-devel
          - ncurses-devel
          - bison
          - bison-devel
          - openldap
          - openldap-devel
          - libcurl-devel
          - libevent
          - libevent-devel
          - expat-devel
          - numactl
        state: latest

    - name: 更新系统
      shell: "yum update -y"
      args:
        warn: False

### 文件拷贝copy.yml：

`$ vim roles/mysql_install/tasks/copy.yml`

    - name: 创建mysql用户组
      group: name={{ MYSQL_USER }}  state=present

    - name: 创建mysql用户
      user: name={{ MYSQL_USER }}  group={{ MYSQL_USER }}  state=present create_home=False shell=/sbin/nologin

    - name: 创建所需目录
      file: name={{ item }} state=directory mode=0755 recurse=yes
      with_items:
      - "{{ SOURCE_DIR }}"
      - "{{ DATA_DIR }}"

    - name: 更改目录属组
      file: name={{ DATA_DIR }} owner={{ MYSQL_USER }} group={{ MYSQL_USER }}

    #当前主机下没有mysql包
    - name: 下载mysql包
      get_url: url={{ DOWNLOAD_URL }} dest={{ SOURCE_DIR }} owner={{ MYSQL_USER }} group={{ MYSQL_USER }}

    #当前主机file目录下已有mysql包
    #- name: 拷贝现有mysql包到所有主机
    #  copy: src=mysql-{{ MYSQL_VER }}-linux-glibc2.12-x86_64.tar.gz dest={{ SOURCE_DIR }} owner={{ MYSQL_USER }} group={{ MYSQL_USER }}

    - name: 解压mysql包
      unarchive: src={{ SOURCE_DIR }}/mysql-{{ MYSQL_VER }}-linux-glibc2.12-x86_64.tar.gz dest=/usr/local owner={{ MYSQL_USER }} group={{ MYSQL_USER }}

    - name: 目录重命名
      shell: "mv /usr/local/mysql-{{ MYSQL_VER }}-linux-glibc2.12-x86_64 {{ BASE_DIR }} && chown -R {{ MYSQL_USER }}:{{ MYSQL_USER }} {{ BASE_DIR }}"

    #复制mysql配置文件
    - name: 拷贝mysql配置文件
      template: src=my.cnf dest=/etc/my.cnf owner=root group=root

    #复制mysql服务文件
    - name: 拷贝mysql服务文件
      template: src=mysqld.service dest=/usr/lib/systemd/system/mysqld.service owner=root group=root

    #复制更改密码脚本
    - name: 拷贝更改密码脚本
      template: src=change_passwd.sh dest={{ SOURCE_DIR }} owner=root group=root

    - name: 创建日志目录
      file: name={{ item }} state=directory owner={{ MYSQL_USER }} group={{ MYSQL_USER }} mode=0755 recurse=yes
      with_items:
      - "/var/log/mysql"
      - "/var/run/mysqld"
      - "{{ BASE_DIR }}/tmp"
      - "{{ BASE_DIR }}/log"

    - name: 创建错误日志文件
      file: dest={{ BASE_DIR }}/log/error.log state=touch owner={{ MYSQL_USER }} group={{ MYSQL_USER }}

### mysql初始化install.yml：

`$ vim roles/mysql_install/tasks/install.yml`

    #初始化安装mysql
    - name: mysql初始化
    shell: "{{ BASE_DIR }}/bin/mysqld --initialize-insecure --user={{ MYSQL_USER }} --basedir={{ BASE_DIR }}  --datadir={{ DATA_DIR }}"

    - name: 拷贝启动脚本到/etc下
    copy: src={{ BASE_DIR }}/support-files/mysql.server dest=/etc/init.d/mysql

    - name: 修改启动脚本_1
    lineinfile:
        dest: /etc/init.d/mysql
        regexp: "^basedir="
        insertbefore: "^# Default value, in seconds, afterwhich the script should timeout waiting"
        line: "basedir={{ BASE_DIR }}"

    - name: 修改启动脚本_2
    lineinfile:
        dest: /etc/init.d/mysql
        regexp: "^datadir="
        insertbefore: "^# Default value, in seconds, afterwhich the script should timeout waiting"
        line: "datadir={{ DATA_DIR }}"

    - name: 修改启动脚本_3  
    file: dest=/etc/init.d/mysql state=file mode=0755

    - name: 配置环境变量
    shell: " if [ `grep {{ BASE_DIR }}/bin /etc/profile |wc -l` -eq 0 ]; then echo export PATH=$PATH:{{ BASE_DIR }}/bin >> /etc/profile && source /etc/profile; else source /etc/profile; fi"

    - name: 启动mysql并开机启动
    shell: "systemctl daemon-reload && systemctl enable mysqld && systemctl start mysqld"

    - name: 设置数据库root密码
    shell: "bash {{ SOURCE_DIR }}/change_passwd.sh"

引用文件main.yml：

`$ vim roles/mysql_install/tasks/main.yml`

    #引用prepare、copy、install模块
    - include: prepare.yml
    - include: copy.yml
    - include: install.yml


## php部分

创建php入口文件，用来调用php_install：

`$ vim php.yml`

    #用于批量安装PHP
    - hosts: webserver
    remote_user: root
    gather_facts: True

    roles:
        - php_install

创建变量

`$ vim roles/php_install/vars/main.yml`

    #定义php安装中的变量
    PHP_VER: 7.2.6
    DOWNLOAD_URL: http://mirrors.sohu.com/php/php-{{ PHP_VER }}.tar.gz
    PHP_USER: php-fpm
    PHP_PORT: 9000
    SOURCE_DIR: /software
    PHP_DIR: /usr/local/php7
    MYSQL_DIR: /usr/local/mysql

创建模板文件:

php主配置文件php-fpm.conf

`$ vim roles/php_install/templates/php-fpm.conf`

    [global]
    pid = {{ PHP_DIR }}/var/run/php-fpm.pid
    error_log = {{ PHP_DIR }}/var/log/php-fpm.log
    [www]
    listen = 127.0.0.1:{{ PHP_PORT }}
    listen.mode = 666
    listen.owner = nobody
    listen.group = nobody
    user = {{ PHP_USER }}
    group = {{ PHP_USER }}
    pm = dynamic
    pm.max_children = 50
    pm.start_servers = 20
    pm.min_spare_servers = 5
    pm.max_spare_servers = 35
    pm.max_requests = 500
    rlimit_files = 1024

文件拷贝copy.yml：

`$ vim roles/php_install/tasks/copy.yml`

    - name: 创建php用户组
    group: name={{ PHP_USER }}  state=present

    - name: 创建php用户
    user: name={{ PHP_USER }}  group={{ PHP_USER }}  state=present create_home=False shell=/sbin/nologin

    #- name: 创建software目录
    #  file: name={{ SOURCE_DIR }} state=directory mode=0755 recurse=yes

    #当前主机下没有libmcrypt依赖包
    - name: 下载依赖包libmcrypt
    get_url: url=http://nchc.dl.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz dest={{ SOURCE_DIR }}

    #当前主机file目录下已有libmcrypt依赖包
    #- name: 拷贝现有libmcrypt依赖包到所有主机
    #  copy: src=libmcrypt-2.5.8.tar.gz dest={{ SOURCE_DIR }}

    #当前主机下没有php包
    - name: 下载php包
    get_url: url={{ DOWNLOAD_URL }} dest={{ SOURCE_DIR }} owner={{ PHP_USER }} group={{ PHP_USER }}

    #当前主机file目录下已有php包
    #- name: 拷贝现有php包到所有主机
    #  copy: src=php-{{ PHP_VER }}.tar.gz dest={{ SOURCE_DIR }} owner={{ PHP_USER }} group={{ PHP_USER }}

    - name: 解压依赖包libmcrypt
    unarchive: src={{ SOURCE_DIR }}/libmcrypt-2.5.8.tar.gz dest={{ SOURCE_DIR }}

    - name: 编译安装libmcrypt
    shell: "cd {{ SOURCE_DIR }}/libmcrypt-2.5.8 && ./configure && make && make install"

    - name: 解压php包
    unarchive: src={{ SOURCE_DIR }}/php-{{ PHP_VER }}.tar.gz dest={{ SOURCE_DIR }} owner={{ PHP_USER }} group={{ PHP_USER }}

编译安装install.yml：

`$ vim roles/php_install/tasks/install.yml`

    #编译php
    - name: 编译php
    shell: "cd {{ SOURCE_DIR }}/php-{{ PHP_VER }} && ./configure --prefix={{ PHP_DIR }} --with-config-file-path={{ PHP_DIR }}/etc --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-mysql={{ MYSQL_DIR }} --with-mysql-sock={{ MYSQL_DIR }}/tmp/mysql.sock --with-iconv-dir --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-bz2 --with-libxml-dir --with-curl --with-gd --with-openssl --with-mhash  --with-xmlrpc --with-pdo-mysql --with-libmbfl --with-onig --with-pear --enable-xml --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --enable-mbregex --enable-fpm --enable-mbstring --enable-pcntl --enable-sockets --enable-zip --enable-soap --enable-opcache --enable-pdo --enable-mysqlnd-compression-support --enable-maintainer-zts  --enable-session --with-fpm-user={{ PHP_USER }} --with-fpm-group={{ PHP_USER }}"
    
    #安装php
    - name: 安装php
    shell: "cd {{ SOURCE_DIR }}/php-{{ PHP_VER }} && make -j 2 && make -j 2 install"

    - name: 创建php-fpm配置目录
    file: name={{ PHP_DIR }}/etc state=directory owner={{ PHP_USER }} group={{ PHP_USER }} mode=0755 recurse=yes

    - name: 修改php-fpm配置_1
    shell: "cd {{ SOURCE_DIR }}/php-{{ PHP_VER }} && cp php.ini-production  {{ PHP_DIR }}/etc/php.ini"
    
    - name: 修改php-fpm配置_2
    lineinfile:
        dest: "{{ PHP_DIR }}/etc/php.ini"
        regexp: "post_max_size = 8M"
        line: "post_max_size = 16M"

    - name: 修改php-fpm配置_3
    lineinfile:
        dest: "{{ PHP_DIR }}/etc/php.ini"
        regexp: "max_execution_time = 30"
        line: "max_execution_time = 300"

    - name: 修改php-fpm配置_4
    lineinfile:
        dest: "{{ PHP_DIR }}/etc/php.ini"
        regexp: "max_input_time = 60"
        line: "max_input_time = 300"
    
    - name: 修改php-fpm配置_5
    lineinfile:
        dest: "{{ PHP_DIR }}/etc/php.ini"
        regexp: ";date.timezone ="
        line: "date.timezone = Asia/Shanghai"

    #复制启动配置文件
    - name: 拷贝启动配置文件
    shell: "cd {{ SOURCE_DIR }}/php-{{ PHP_VER }} && cp sapi/fpm/init.d.php-fpm  /etc/init.d/php-fpm && chmod +x /etc/init.d/php-fpm"
    
    #复制php主配置文件
    - name: 拷贝php主配置文件
    template: src=php-fpm.conf dest={{ PHP_DIR }}/etc/php-fpm.conf owner={{ PHP_USER }} group={{ PHP_USER }}

    #编译安装ldap模块
    - name: 编译安装ldap模块
    shell: "cd {{ SOURCE_DIR }}/php-{{ PHP_VER }}/ext/ldap && cp -af /usr/lib64/libldap* /usr/lib/ && {{ PHP_DIR }}/bin/phpize && ./configure --with-php-config={{ PHP_DIR }}/bin/php-config && make && make install"

    - name: 修改php-fpm配置_6
    lineinfile:
        dest: "{{ PHP_DIR }}/etc/php.ini"
        regexp: ";extension=bz2"
        line: "aextension=ldap.so"
    
    #编译安装gettext模块
    - name: 编译安装gettext模块
    shell: "cd {{ SOURCE_DIR }}/php-{{ PHP_VER }}/ext/gettext && cp -af /usr/lib64/libldap* /usr/lib/ && {{ PHP_DIR }}/bin/phpize && ./configure --with-php-config={{ PHP_DIR }}/bin/php-config && make && make install"

    - name: 修改php-fpm配置_7
    lineinfile:
        dest: "{{ PHP_DIR }}/etc/php.ini"
        regexp: ";extension=bz2"
        line: "aextension=gettext.so"

    - name: 启动php并开机启动
    shell: "chkconfig --add php-fpm && chkconfig php-fpm on && /etc/init.d/php-fpm start"

引用文件main.yml：

`$ vim roles/php_install/tasks/main.yml`

    #引用prepare、copy、install模块
    #- include: prepare.yml
    - include: copy.yml
    - include: install.yml

## nginx部分

创建nginx入口文件，用来调用nginx_install：

`$ vim nginx.yml` 

    #用于批量安装Nginx
    - hosts: webserver
    remote_user: root
    gather_facts: True

    roles:
        - nginx_install

创建变量：

`$ vim roles/nginx_install/vars/main.yml`

    #定义nginx安装中的变量
    NGINX_VER: 1.15.0
    DOWNLOAD_URL: http://nginx.org/download/nginx-{{ NGINX_VER }}.tar.gz
    NGINX_USER: nginx
    NGINX_PORT: 80
    SOURCE_DIR: /software
    NGINX_DIR: /usr/local/nginx
    DATA_DIR: /data/nginx

创建模板文件：
nginx主配置文件nginx.conf

`$ vim roles/nginx_install/templates/nginx.conf`

    user nobody nobody;	
    worker_processes  1;
    error_log {{ DATA_DIR }}/log/error.log crit;
    pid /run/nginx.pid;
    worker_rlimit_nofile 51200;
    events {
        worker_connections  1024;
    }
    http {
        include       mime.types;
        log_format  main  '$remote_addr - $remote_user [$time_local] "\$request" '
                        '$status $body_bytes_sent "$http_referer" '
                        '"$http_user_agent" "$http_x_forwarded_for"';

        access_log  {{ DATA_DIR }}/log/access.log  main;

        server_tokens       off;
        sendfile        	on;
        send_timeout        3m;
        tcp_nopush          on;
        tcp_nodelay         on;
        keepalive_timeout   65;
        types_hash_max_size 2048;

        client_header_timeout 3m;
        client_body_timeout 3m;
        connection_pool_size 256;
        client_header_buffer_size 1k;
        large_client_header_buffers 8 4k;
        request_pool_size 4k;
        output_buffers 4 32k;
        postpone_output 1460;
        client_max_body_size 10m;
        client_body_buffer_size 256k;
        client_body_temp_path {{ NGINX_DIR }}/client_body_temp;
        proxy_temp_path {{ NGINX_DIR }}/proxy_temp;
        fastcgi_temp_path {{ NGINX_DIR }}/fastcgi_temp;
        fastcgi_intercept_errors on;    

        gzip on;
        gzip_min_length 1k;
        gzip_buffers 4 8k;
        gzip_comp_level 5;
        gzip_http_version 1.1;
        gzip_types text/plain application/x-javascript text/css text/htm 
        application/xml;

        default_type  application/octet-stream;
        include  {{ NGINX_DIR }}/conf/vhost/*.conf;
    }

nginx vhost配置文件server.conf

`$ vim roles/nginx_install/templates/server.conf`

    server {
        listen       80;
        server_name  localhost;
        location / {
            root   {{ NGINX_DIR }}/html;
            index  index.php index.html index.htm;
        }
        
        error_page   500 502 503 504  /50x.html;
            location = /50x.html {
                root   html;
            }	

        location ~ \.php$ {
        root   {{ NGINX_DIR }}/html;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
        }
    }

nginx额外配置文件fastcgi_params

`$ vim roles/nginx_install/templates/fastcgi_params`

    fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
    fastcgi_param  SERVER_SOFTWARE    nginx;
    fastcgi_param  QUERY_STRING       $query_string;
    fastcgi_param  REQUEST_METHOD     $request_method;
    fastcgi_param  CONTENT_TYPE       $content_type;
    fastcgi_param  CONTENT_LENGTH     $content_length;
    fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;
    fastcgi_param  SCRIPT_NAME        $fastcgi_script_name;
    fastcgi_param  REQUEST_URI        $request_uri;
    fastcgi_param  DOCUMENT_URI       $document_uri;
    fastcgi_param  DOCUMENT_ROOT      $document_root;
    fastcgi_param  SERVER_PROTOCOL    $server_protocol;
    fastcgi_param  REMOTE_ADDR        $remote_addr;
    fastcgi_param  REMOTE_PORT        $remote_port;
    fastcgi_param  SERVER_ADDR        $server_addr;
    fastcgi_param  SERVER_PORT        $server_port;
    fastcgi_param  SERVER_NAME        $server_name;

nginx服务文件nginx.service

`$ vim roles/nginx_install/templates/nginx.service`

    [Unit]
    Description=The nginx HTTP and reverse proxy server
    After=network.target remote-fs.target nss-lookup.target

    [Service]
    Type=forking
    PIDFile=/run/nginx.pid
    # Nginx will fail to start if /run/nginx.pid already exists but has the wrong
    # SELinux context. This might happen when running `nginx -t` from the cmdline.
    # https://bugzilla.redhat.com/show_bug.cgi?id=1268621
    ExecStartPre=/usr/bin/rm -f /run/nginx.pid
    ExecStartPre={{ NGINX_DIR }}/sbin/nginx -t
    ExecStart={{ NGINX_DIR }}/sbin/nginx
    ExecReload=/bin/kill -s HUP $MAINPID
    KillSignal=SIGQUIT
    TimeoutStopSec=5
    KillMode=process
    PrivateTmp=true

    [Install]
    WantedBy=multi-user.target

文件拷贝copy.yml：

`$ vim roles/nginx_install/tasks/copy.yml`

    - name: 创建nginx用户组
    group: name={{ NGINX_USER }}  state=present

    - name: 创建nginx用户
    user: name={{ NGINX_USER }}  group={{ NGINX_USER }}  state=present create_home=False shell=/sbin/nologin

    #- name: 创建software目录
    #  file: name={{ SOURCE_DIR }} state=directory mode=0755 recurse=yes
    
    - name: 创建日志目录
    file: name={{ item }} state=directory owner={{ NGINX_USER }} group={{ NGINX_USER }} mode=0755 recurse=yes
    with_items:
    - "{{ DATA_DIR }}"
    - "{{ DATA_DIR }}/log"
    
    - name: 创建日志文件
    file: name={{ item }} state=touch owner={{ NGINX_USER }} group={{ NGINX_USER }} mode=0644
    with_items:
    - "{{ DATA_DIR }}/log/access.log"
    - "{{ DATA_DIR }}/log/error.log"

    #当前主机下没有nginx包
    - name: 下载nginx包
    get_url: url={{ DOWNLOAD_URL }} dest={{ SOURCE_DIR }} owner={{ NGINX_USER }} group={{ NGINX_USER }}

    #当前主机file目录下已有nginx包
    #- name: 拷贝现有nginx包到所有主机
    #  copy: src=nginx-{{ NGINX_VER }}.tar.gz dest={{ SOURCE_DIR }} owner={{ NGINX_USER }} group={{ NGINX_USER }}

    - name: 解压nginx包
    unarchive: src={{ SOURCE_DIR }}/nginx-{{ NGINX_VER }}.tar.gz dest={{ SOURCE_DIR }} owner={{ NGINX_USER }} group={{ NGINX_USER }}

    #复制nginx服务文件
    - name: 拷贝nginx服务文件
    template: src=nginx.service dest=/usr/lib/systemd/system/nginx.service owner=root group=root

编译安装install.yml：

`$ vim roles/nginx_install/tasks/install.yml`

    #编译nginx
    - name: 编译nginx
    shell: "cd {{ SOURCE_DIR }}/nginx-{{ NGINX_VER }} && ./configure --prefix={{ NGINX_DIR }} --user={{ NGINX_USER }} --group={{ NGINX_USER }} --http-log-path={{ DATA_DIR }}/log/access.log --error-log-path={{ DATA_DIR }}/log/error.log --with-http_ssl_module --with-http_v2_module --with-http_realip_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_image_filter_module --with-http_stub_status_module"
    
    #安装nginx
    - name: 安装nginx
    shell: "cd {{ SOURCE_DIR }}/nginx-{{ NGINX_VER }} && make && make install"
    
    #复制nginx主配置文件
    - name: 拷贝nginx主配置文件
    template: src=nginx.conf dest={{ NGINX_DIR }}/conf/nginx.conf owner={{ NGINX_USER }} group={{ NGINX_USER }}

    - name: 创建vhost配置文件目录
    file: name={{ NGINX_DIR }}/conf/vhost state=directory owner={{ NGINX_USER }} group={{ NGINX_USER }} mode=0755 recurse=yes

    #复制nginx vhost配置文件
    - name: 拷贝nginx vhost配置文件
    template: src=server.conf dest={{ NGINX_DIR }}/conf/vhost/server.conf owner={{ NGINX_USER }} group={{ NGINX_USER }} mode=0644
    
    #复制nginx额外配置文件
    - name: 拷贝nginx额外配置文件
    template: src=fastcgi_params dest={{ NGINX_DIR }}/conf/fastcgi_params owner={{ NGINX_USER }} group={{ NGINX_USER }} mode=0644

    - name: 配置环境变量
    shell: " if [ `grep {{ NGINX_DIR }}/sbin /etc/profile |wc -l` -eq 0 ]; then echo export PATH=$PATH:{{ NGINX_DIR }}/sbin >> /etc/profile && source /etc/profile; else source /etc/profile; fi"

    - name: 启动nginx并开机启动
    shell: "systemctl daemon-reload && systemctl enable nginx && systemctl start nginx"
    
    - name: 添加php测试页index.php
    shell: " echo '<?php phpinfo(); ?>' >> {{ NGINX_DIR }}/html/index.php"

引用文件main.yml：

`$ vim roles/nginx_install/tasks/main.yml`

    #引用prepare、copy、install模块
    # - include: prepare.yml
    - include: copy.yml
    - include: install.yml

## 安装测试

执行安装：
`$ ansible-playbook lnmp.yml`

    # netstat -lntp 
    Active Internet connections (only servers)
    Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
    tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      60211/nginx: master 
    tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      14395/sshd          
    tcp        0      0 127.0.0.1:25            0.0.0.0:*               LISTEN      23263/master        
    tcp        0      0 127.0.0.1:9000          0.0.0.0:*               LISTEN      55690/php-fpm: mast 
    tcp6       0      0 :::22                   :::*                    LISTEN      14395/sshd          
    tcp6       0      0 ::1:25                  :::*                    LISTEN      23263/master        
    tcp6       0      0 :::3306                 :::*                    LISTEN      7929/mysqld 
