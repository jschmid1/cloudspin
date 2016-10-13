#
# spec file for package clouspin
#
# Copyright (c) 2016 SUSE LINUX Products GmbH, Nuernberg, Germany.
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via http://bugs.opensuse.org/
#

Name:           cloudspin
Version:        0.1+git.1465386405.382dcd3
Release:        0
License:        GPL-2.0
Summary:        Spawn a set of machines in the cloud
Url:            https://gitlab.suse.de/jschmid1/cloudspin
Group:          Productivity/Other 
Source:         cloudspin-%{version}.tar.xz
BuildArch:      noarch
Requires:       terraform
BuildRoot:      %{_tmppath}/%{name}-%{version}
%define _config_dir %{_sysconfdir}/%{name}

%description
Parameterizes and extends terraform to fit the needs of ceph development in conjunction with salt.

%prep
%setup

%build

%install
%{__mkdir_p} %{buildroot}%{_bindir}/
%{__mkdir_p} %{buildroot}/%{_config_dir}/templates/withmaster
%{__mkdir_p} %{buildroot}/%{_config_dir}/templates/nomaster
%{__install} -m755 %{name} %{buildroot}%{_bindir}/
%{__install} -m755 templates/withmaster/* %{buildroot}/%{_config_dir}/templates/withmaster/
%{__install} -m755 templates/nomaster/* %{buildroot}/%{_config_dir}/templates/nomaster/


%files
%defattr(-,root,root)
%doc README.md LICENSE
%{_bindir}/%{name}
%config %{_sysconfdir}/%{name}
%config %{_sysconfdir}/%{name}/templates/*


%changelog 
