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

To build RHEL containers, it is necessary to include registration with RHN of the container runtime operating system.To obtain a RHN username/password/pool id, contact Red Hat. Use a template’s header block overrides file, add the following:

```shell
RUN subscription-manager register --user=<user-name> \
--password=<password> && subscription-manager attach --pool <pool-id>
```

### Dockerfile Customisation

As of the Newton release, the kolla-build tool provides a Jinja2 based mechanism which allows operators to customise the Dockerfiles used to generate Kolla images.

This offers a lot of flexibility on how images are built, for example, installing extra packages as part of the build, tweaking settings, installing plugins, and numerous other capabilities. Some of these examples are described in more detail below.

> The docker file for each image is found in docker/<image name> directory.

### Generic Customisation

Anywhere the line {% block ... %} appears may be modified. The Kolla community have added blocks throughout the Dockerfiles where we think they will be useful, however, operators are free to submit more if the ones provided are inadequate.

The following is an example of how an operator would modify the setup steps within the Horizon Dockerfile.

First, create a file to contain the customisations, for example: template-overrides.j2. In this place the following:

```shell
{% extends parent_template %}

# Horizon
{% block horizon_redhat_binary_setup %}
RUN useradd --user-group myuser
{% endblock %}
```

Then rebuild the horizon image, passing the --template-override argument:
`kolla-build --template-override template-overrides.j2 horizon`

> The above example will replace all contents from the original block. Hence in many cases one may want to copy the original contents of the block before making changes.
> More specific functionality such as removing/appending entries is available for packages, described in the next section.

### Package Customisation

Packages installed as part of a container build can be overridden, appended to, and deleted. Taking the Horizon example, the following packages are installed as part of a binary install type build:

+ openstack-dashboard
+ httpd
+ mod_wsgi
+ mod_ssl
+ gettext

To add a package to this list, say, iproute, first create a file, for example, template-overrides.j2. In this place the following:

```shell
{% extends parent_template %}

# Horizon
{% set horizon_packages_append = ['iproute'] %}
```

Then rebuild the horizon image, passing the --template-override argument:

`kolla-build --template-override template-overrides.j2 horizon`

Alternatively template_override can be set in kolla-build.conf.

The append suffix in the above example carries special significance. It indicates the operation taken on the package list. The following is a complete list of operations available:

override
    Replace the default packages with a custom list.
append
    Add a package to the default list.
remove
    Remove a package from the default list. 

### Using a different base image

Base-image can be specified by argument --base-image. For example:

`kolla-build --base-image registry.access.redhat.com/rhel7/rhel --base rhel`

### Plugin Functionality

The Dockerfile customisation mechanism is also useful for adding/installing plugins to services. An example of this is Neutron’s third party L2 drivers.

The bottom of each Dockerfile contains two blocks, image_name_footer, and footer. The image_name_footer is intended for image specific modifications, while the footer can be used to apply a common set of modifications to every Dockerfile.

For example, to add the networking-cisco plugin to the neutron_server image, one may want to add the following to the template-override file:

```shell
{% extends parent_template %}

{% block neutron_server_footer %}
RUN git clone https://git.openstack.org/openstack/networking-cisco \
    && pip --no-cache-dir install networking-cisco
{% endblock %}
```

Astute readers may notice there is one problem with this however. Assuming nothing else in the Dockerfile changes for a period of time, the above RUN statement will be cached by Docker, meaning new commits added to the Git repository may be missed on subsequent builds. To solve this the Kolla build tool also supports cloning additional repositories at build time, which will be automatically made available to the build, within an archive named plugins-archive.

The following is available for source build types only.

To use this, add a section to /etc/kolla/kolla-build.conf in the following format:

`[<image>-plugin-<plugin-name>]`

Where <image> is the image that the plugin should be installed into, and <plugin-name> is the chosen plugin identifier.

Continuing with the above example, add the following to /etc/kolla/kolla-build.conf:

```shell
[neutron-server-plugin-networking-cisco]
type = git
location = https://git.openstack.org/openstack/networking-cisco
reference = master
```

The build will clone the repository, resulting in the following archive structure:

plugins-archive.tar
|__ plugins
    |__networking-cisco

The template now becomes:

```shell
{% block neutron_server_footer %}
ADD plugins-archive /
pip --no-cache-dir install /plugins/*
{% endblock %}
```

Many of the Dockerfiles already copy the plugins-archive to the image and install available plugins at build time.

## Additions Functionality

The Dockerfile customisation mechanism is also useful for adding/installing additions into images. An example of this is adding your jenkins job build metadata (say formatted into a jenkins.json file) into the image.

Similarly to the plugins mechanism, the Kolla build tool also supports cloning additional repositories at build time, which will be automatically made available to the build, within an archive named additions-archive. The main difference between plugins-archive and additions-archive is that plugins-archive is copied to the relevant images and processed to install available plugins while additions-archive processing is left to the Kolla user.

The following is available for source build types only.

To use this, add a section to /etc/kolla/kolla-build.conf in the following format:

[<image>-additions-<additions-name>]

Where <image> is the image that the plugin should be installed into, and <additions-name> is the chosen additions identifier.

Continuing with the above example, add the following to /etc/kolla/kolla-build.conf file:

```shell
[neutron-server-additions-jenkins]
type = local
location = /path/to/your/jenkins/data
```

The build will copy the directory, resulting in the following archive structure:

additions-archive.tar
|__ additions
    |__jenkins

Alternatively, it is also possible to create an additions-archive.tar file yourself without passing by /etc/kolla/kolla-build.conf in order to use the feature for binary build type.

The template now becomes:

```shell
{% block neutron_server_footer %}
ADD additions-archive /
RUN cp /additions/jenkins/jenkins.json /jenkins.json
{% endblock %}
```

## Custom Repos

### Red Hat

The build method allows the operator to build containers from custom repos. The repos are accepted as a list of comma separated values and can be in the form of .repo, .rpm, or a url. See examples below.

Update rpm_setup_config in /etc/kolla/kolla-build.conf:

`rpm_setup_config = https://trunk.rdoproject.org/centos7/currrent/delorean.repo,https://trunk.rdoproject.org/centos7/delorean-deps.repo`

If specifying a .repo file, each .repo file will need to exist in the same directory as the base Dockerfile (kolla/docker/base):

`rpm_setup_config = epel.repo,delorean.repo,delorean-deps.repo`


### Ubuntu

For Debian based images, additional apt sources may be added to the build as follows:

`apt_sources_list = custom.list`

The opendaylight-template-overrides.j2 template override shows how to build an OpenDaylight container image with a different version than the one packaged with the distro.
Building OpenDaylight Container Images¶
kolla-build.conf¶

Point to the desired version of OpenDaylight in kolla-build.conf:

```shell
[opendaylight]
type = url
location = https://nexus.opendaylight.org/content/repositories/opendaylight.release/org/opendaylight/integration/distribution-karaf/0.6.2-Carbon/distribution-karaf-0.6.2-Carbon.tar.gz
```

Build the container by executing the following command:

`kolla-build --type source --template-override contrib/template-override/opendaylight-template-overrides.j2 opendaylight`

