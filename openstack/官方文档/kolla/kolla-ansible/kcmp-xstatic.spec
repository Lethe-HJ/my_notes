%{!?upstream_version: %global upstream_version %{version}%{?milestone}}
%global sname xstatic

%global common_desc \
XStatic is XStatic files for kcmp.

Name:             xstatic
Epoch:            1
Version:          1.0.1
Release:          1.kylin
Summary:          XStatic files for kcmp
License:          ASL 2.0
URL:              http://zhongshengping@dev.kylincloud.me/gerrit/kylincloud/kcmp-xtstic
Source0:          %{name}-%{version}.tar.gz
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
%{python2_sitelib}/%{sname}

%clean
rm -rf $RPM_BUILD_ROOT


%changelog

* 1.0.1

- Add bootstrap\_scss
- Add MANIFEST.in

* 1.0.0

- First commit
- Initial empty repository
