    ps aux|grep ceph |awk '{print $2}'|xargs kill -9
    ps -ef|grep ceph
    umount /var/lib/ceph/osd/*
    rm -rf /var/lib/ceph/osd/*
    rm -rf /var/lib/ceph/mon/*
    rm -rf /var/lib/ceph/mds/*
    rm -rf /var/lib/ceph/bootstrap-mds/*
    rm -rf /var/lib/ceph/bootstrap-osd/*
    rm -rf /var/lib/ceph/bootstrap-rgw/*
    rm -rf /var/lib/ceph/bootstrap-mgr/*
    rm -rf /var/lib/ceph/tmp/*
    rm -rf /etc/ceph/*
    rm -rf /var/run/ceph/*
    rm ~/cluster/*