%{!?upstream_version: %global upstream_version %{version}%{?milestone}}
%global sname kcmp

%global common_desc \
KCMP is also called as Kylincloud Management Platform, which provides a web
based user interface to cloud services.

Name:             kcmp
Epoch:            1
Version:          2017.1.40.dev8
Release:          1.kylin
Summary:          provides a web based user interface to cloud services
License:          ASL 2.0
URL:              http://zhongshengping@dev.kylincloud.me/gerrit/kylincloud/
#Source0:          %{name}-%{version}.tar.gz
Source0:          kcmp-2017.1.40.dev8.tar.gz
BuildArch:        noarch


%description
%{common_desc}

BuildRequires:  git
%prep
%autosetup -n %{name}-%{upstream_version} -S git

%py_req_cleanup

%build
%py2_build


%install

%py2_install

%files -n %{sname}
%doc README.rst
%{python2_sitelib}/%{sname}
%{python2_sitelib}/kcmp-2017.1.40.dev8-py2.7.egg-info
%{python2_sitelib}/alipay
%{python2_sitelib}/chunked_upload
%{python2_sitelib}/consumptions
%{python2_sitelib}/kylin_dashboard
%{python2_sitelib}/messages_extends


%clean
rm -rf $RPM_BUILD_ROOT