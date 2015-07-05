# sssd

#### Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration options and additional functionality](#usage)
3. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Credits](#credits)

## Overview

This module installs and configures sssd.

## Usage

Example configuration:

```puppet
class {'::sssd':
  config => {
    'sssd' => {
      'domains'             => 'ad.example.com',
      'config_file_version' => 2,
      'services'            => ['nss', 'pam'],
    }
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
Set to 'true' to enable auto-creation of home directories on user login, using oddjobd-mkhomedir. This is only needed for RedHat/CentOS.
Type: boolean
Default: true on osfamily RedHat, false on osfamily Debian.

## Limitations

Testet on Fedora 22, RHEL6,7 and Ubuntu 14.04

## Credits

* sssd.conf template and authconfig/mkhomedir code by Chadwick Banning - https://github.com/walkamongus/sssd
