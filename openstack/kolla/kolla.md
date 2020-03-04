# Administrator Guide

## Building Container Images

The `kolla-build` command is responsible for building Docker images.

>  Use the `python tools/build.py` script instead of `kolla-build` command in all below instructions.


### Generating kolla-build.conf

`pip install tox`
`cd kolla/`
`tox -e genconfig`

The location of the generated configuration file is `etc/kolla/kolla-build.conf`, it can also be copied to `/etc/kolla`

### Building kolla images

In general, images are built like this:
`kolla-build`

By default, the above command would build all images based on CentOS image.

The operator can change the base distro with the `-b` option:

`kolla-build -b ubuntu`

t is possible to build only a subset of images by specifying them on the command line:

`kolla-build keystone`

Multiple names may be specified on the command line:

`kolla-build keystone nova`

The set of images built can be defined as a profile in the profiles section of kolla-build.conf. Later, profile can be specified by --profile CLI argument or profile option in kolla-build.conf. 

For example, due to Magnum requires Heat, add the following profile to profiles section in kolla-build.conf:

```shell
[profiles]
magnum = magnum,heat
```

These images can be built using command line:

`kolla-build --profile magnum`

Or put following line to DEFAULT section in kolla-build.conf file:

```shell
[DEFAULT]
profile = magnum
```

The kolla-build uses kolla as default Docker namespace. This is controlled with the -n command line option. To push images to a Dockerhub repository named mykollarepo:

`kolla-build -n mykollarepo --push`

To push images to a local registry, use --registry flag:

`kolla-build --registry 172.22.2.81:5000 --push`

### Build OpenStack from source

When building images, there are two methods of the OpenStack install. One is binary. Another is source. The binary means that OpenStack will be installed from apt/yum. And the source means that OpenStack will be installed from source code. The default method of the OpenStack install is binary. It can be changed to source using the -t option:

`kolla-build -t source`

The locations of OpenStack source code are written in etc/kolla/kolla-build.conf. Now the source type supports url, git, and local. The location of the local source type can point to either a directory containing the source code or to a tarball of the source. The local source type permits to make the best use of the Docker cache.

The etc/kolla/kolla-build.conf file looks like:
```shell
[glance-base]
type = url
location = http://tarballs.openstack.org/glance/glance-master.tar.gz

[keystone-base]
type = git
location = https://git.openstack.org/openstack/keystone
reference = stable/mitaka

[heat-base]
type = local
location = /home/kolla/src/heat

[ironic-base]
type = local
location = /tmp/ironic.tar.gz
```

