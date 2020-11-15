修改docker默认网段



vim /etc/docker/daemon.json（这里没有这个文件的话，自行创建）

```
{
    "bip":"192.168.0.1/24"
}
```

重启docker 

```
systemctl restart docker
```



`docker exec -it name /bin/bash`

` docker cp 92c592477948:/sponge.sql ./`

`mysqldump -h127.0.0.1 -p3306 -uroot -phujin666.. sponge > sponge.sql`