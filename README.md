# sssd

[![Build Status](https://travis-ci.org/sgnl05/sgnl05-sssd.svg)](https://travis-ci.org/sgnl05/sgnl05-sssd)
[![Puppet Forge](https://img.shields.io/puppetforge/v/sgnl05/sssd.svg)](https://forge.puppetlabs.com/sgnl05/sssd)
[![Puppet Forge Downloads](https://img.shields.io/puppetforge/dt/sgnl05/sssd.svg)](https://forge.puppetlabs.com/sgnl05/sssd)
[![Puppet Forge Score](https://img.shields.io/puppetforge/f/sgnl05/sssd.svg)](https://forge.puppetlabs.com/sgnl05/sssd/scores)
[![Issue Stats](http://issuestats.com/github/sgnl05/sgnl05-sssd/badge/pr?style=flat)](http://issuestats.com/github/sgnl05/sgnl05-sssd)

#### Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration options and additional functionality](#usage)
3. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Credits](#credits)

## Overview

This module installs and configures SSSD (System Security Services Daemon)

[SSSD][0] is used to provide access to identity and authentication remote resource through a common framework that can provide caching and offline support to the system.

## Usage

Example configuration:

```puppet
class {'::sssd':
  config => {
    'sssd' => {
      'domains'             => 'ad.example.com',
      'config_file_version' => 2,
      'services'            => ['nss', 'pam'],
    },
    'domain/ad.example.com' => {
      'ad_domain'                      => 'ad.example.com',
      'ad_server'                      => ['server01.ad.example.com', 'server02.ad.example.com'],
      'krb5_realm'                     => 'AD.EXAMPLE.COM',
      'realmd_tags'                    => 'joined-with-samba',
      'cache_credentials'              => true,
      'id_provider'                    => 'ad',
      'krb5_store_password_if_offline' => true,
      'default_shell'                  => '/bin/bash',
      'ldap_id_mapping'                => false,
      'use_fully_qualified_names'      => false,
      'fallback_homedir'               => '/home/%d/%u',
      'access_provider'                => 'simple',
      'simple_allow_groups'            => ['admins', 'users'],
    }
  }
}
```

...or the same config in Hiera:

```yaml
sssd::config:
  'sssd':
    'domains': 'ad.example.com'
    'config_file_version': 2
    'services':
      - 'nss'
      - 'pam'
  'domain/ad.example.com':
    'ad_domain': 'ad.example.com'
    'ad_server':
      - 'server01.ad.example.com'
      - 'server02.ad.example.com'
    'krb5_realm': 'AD.EXAMPLE.COM'
    'realmd_tags': 'joined-with-samba'
    'cache_credentials': true
    'id_provider': 'ad'
    'krb5_store_password_if_offline': true
    'default_shell': '/bin/bash'
    'ldap_id_mapping': false
    'use_fully_qualified_names': false
    'fallback_homedir': '/home/%d/%u'
    'access_provider': 'simple'
    'simple_allow_groups':
      - 'admins'
      - 'users'
```

Will be represented in sssd.conf like this:

```ini
[sssd]
domains = ad.example.com
config_file_version = 2
services = nss, pam

[domain/ad.example.com]
ad_domain = ad.example.com
ad_server = server01.ad.example.com, server02.ad.example.com
krb5_realm = AD.EXAMPLE.COM
realmd_tags = joined-with-samba
cache_credentials = true
id_provider = ad
krb5_store_password_if_offline = true
default_shell = /bin/bash
ldap_id_mapping = false
use_fully_qualified_names = false
fallback_homedir = /home/%d/%u
access_provider = simple
simple_allow_groups = admins, users
```

Tip: Using 'ad' as `id_provider` require you to run 'adcli join domain' on the target node. *adcli join* creates a computer account in the domain for the local machine, and sets up a keytab for the machine.

Example:

```bash
$ sudo adcli join ad.example.com
```

## Reference

#####`ensure`
Defines if sssd and its relevant packages are to be installed or removed. Valid values are 'present' and 'absent'.
Type: string
Default: present

#####`config`
Configuration options stuctured like the sssd.conf file. Array values will be joined into comma-separated lists.
Type: hash
Default:
```puppet
config => {
  'sssd' => {
    'config_file_version' => '2',
    'services'            => 'nss, pam',
    'domains'             => 'ad.example.com',
  },
    'domain/ad.example.com' => {
      'id_provider'       => 'ad',
      'krb5_realm'        => 'AD.EXAMPLE.COM',
      'cache_credentials' => true,
  },
}
```

#####`mkhomedir`
Set to 'true' to enable auto-creation of home directories on user login.
Type: boolean
Default: true

## Limitations

Tested on:
* Fedora 22,23
* (RHEL|CentOS|OracleLinux) 5,6,7
* Ubuntu 14.04

## Credits

* sssd.conf template from [walkamongus-sssd][1] by Chadwick Banning
* Anchor pattern, mkhomedir code, RHEL5 support and spec tests by [Chris Edester][2]
* service_ensure option by [sd-robbruce][3]
* sssd.conf consistency during first Puppet run by [ndelic0][4]
* Non-sorting config keys for newer ruby versions by [gizmoguy][5]

[0]: https://fedorahosted.org/sssd/
[1]: https://github.com/walkamongus/sssd
[2]: https://github.com/edestecd
[3]: https://github.com/sd-robbruce
[4]: https://github.com/ndelic0
[5]: https://github.com/gizmoguy
