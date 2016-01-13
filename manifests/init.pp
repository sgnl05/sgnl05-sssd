# == Class: sssd
#
# Configures and installs SSSD
#
# === Parameters
#
# [*ensure*]
#   Ensure if sssd_package and extra_packages is to be present or absent.
#
# [*config*]
#   Hash containing entire SSSD config.
#
# [*sssd_package*]
#   Name of the sssd package. Only set this if your patform is not supported or
#   you know what you're doing.
#
# [*extra_packages*]
#   Array with extra packages to be installed
#
# [*mkhomedir*]
#   Boolean. Manage auto-creation of home directories on user login.
#
# [*enable_mkhomedir_flags*]
#   Flags to use with authconfig to enable auto-creation of home directories.
#
# [*disable_mkhomedir_flags*]
#   Flags to use with authconfig to disable auto-creation of home directories.
#
# [*service_ensure*]
#   Ensure if services should be running/stopped
#
# === Examples
#
# class {'::sssd':
#   config => {
#     'sssd' => {
#       'domains'             => 'ad.example.com',
#       'config_file_version' => 2,
#       'services'            => ['nss', 'pam'],
#     }
#     'domain/ad.example.com' => {
#       'ad_domain'                      => 'ad.example.com',
#       'ad_server'                      => ['server01.ad.example.com', 'server02.ad.example.com'],
#       'krb5_realm'                     => 'AD.EXAMPLE.COM',
#       'realmd_tags'                    => 'joined-with-samba',
#       'cache_credentials'              => true,
#       'id_provider'                    => 'ad',
#       'krb5_store_password_if_offline' => true,
#       'default_shell'                  => '/bin/bash',
#       'ldap_id_mapping'                => false,
#       'use_fully_qualified_names'      => false,
#       'fallback_homedir'               => '/home/%d/%u',
#       'access_provider'                => 'simple',
#       'simple_allow_groups'            => ['admins', 'users'],
#     }
#   }
# }
#
# === Authors
#
# Gjermund Jensvoll <gjerjens@gmail.com>
#
# === Copyright
#
# Copyright 2015 Gjermund Jensvoll
#
class sssd (
  $ensure                  = $sssd::params::ensure,
  $config                  = $sssd::params::config,
  $sssd_package            = $sssd::params::sssd_package,
  $sssd_service            = $sssd::params::sssd_service,
  $extra_packages          = $sssd::params::extra_packages,
  $extra_packages_ensure   = $sssd::params::extra_packages_ensure,
  $config_file             = $sssd::params::config_file,
  $config_template         = $sssd::params::config_template,
  $mkhomedir               = $sssd::params::mkhomedir,
  $manage_oddjobd          = $sssd::params::manage_oddjobd,
  $service_ensure          = $sssd::params::service_ensure,
  $enable_mkhomedir_flags  = $sssd::params::enable_mkhomedir_flags,
  $disable_mkhomedir_flags = $sssd::params::disable_mkhomedir_flags,
) inherits sssd::params {

  validate_re($ensure, '^(present|absent)$',
  "${ensure} is not supported for ensure.
  Allowed values are 'present' and 'absent'.")

  validate_string(
    $sssd_package,
    $sssd_service,
    $config_template
  )

  validate_array(
    $extra_packages,
    $enable_mkhomedir_flags,
    $disable_mkhomedir_flags
  )

  validate_absolute_path(
    $config_file
  )

  validate_bool(
    $mkhomedir
  )

  validate_hash(
    $config
  )

  validate_re($service_ensure, '^running|true|stopped|false$')

  anchor { 'sssd::begin': } ->
  class { '::sssd::install': } ->
  class { '::sssd::config': } ~>
  class { '::sssd::service': } ->
  anchor { 'sssd::end': }

}
