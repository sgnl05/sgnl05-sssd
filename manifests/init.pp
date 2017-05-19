# == Class: sssd
#
# Installs and configures SSSD
#
# === Parameters
#
# [*ensure*]
#   Ensure if the sssd config file is to be present or absent.
#
# [*config*]
#   Hash containing entire SSSD config.
#
# [*sssd_package*]
#   Name of the sssd package. Only set this if your platform is not supported or
#   you know what you're doing.
#
# [*sssd_package_ensure*]
#   Sets the ensure parameter of the sssd package.
#
# [*sssd_service*]
#   Name of the sssd service.
#
# [*extra_packages*]
#   Array of extra packages.
#
# [*extra_packages_ensure*]
#   Boolean. Ensure if extra packages are to be installed.
#
# [*config_file*]
#   Path to the sssd config file.
#
# [*config_template*]
#   Defines the template used for the sssd config.
#
# [*mkhomedir*]
#   Boolean. Manage auto-creation of home directories on user login.
#
# [*pamaccess*]
#   Boolean. Check access.conf during account authorization.
#
# [*manage_oddjobd*]
#   Boolean. Manage the oddjobd service.
#
# [*service_ensure*]
#   Ensure if services should be running/stopped
#
# [*service_dependencies*]
#   Array of service resource names to manage before managing sssd related
#   services. Intended to be used to manage messagebus service to prevent
#   `Error: Could not start Service[oddjobd]`.
#
# [*enable_mkhomedir_flags*]
#   Flags to use with authconfig to enable auto-creation of home directories.
#
# [*disable_mkhomedir_flags*]
#   Flags to use with authconfig to disable auto-creation of home directories.
#
class sssd (
  Enum['present', 'absent']$ensure  = $sssd::params::ensure,
  Hash $config = $sssd::params::config,
  String $sssd_package = $sssd::params::sssd_package,
  String $sssd_package_ensure = $sssd::params::sssd_package_ensure,
  String $sssd_service = $sssd::params::sssd_service,
  Array $extra_packages = $sssd::params::extra_packages,
  $extra_packages_ensure = $sssd::params::extra_packages_ensure,
  $config_file = $sssd::params::config_file,
  String $config_template = $sssd::params::config_template,
  Boolean $mkhomedir = $sssd::params::mkhomedir,
  $manage_oddjobd = $sssd::params::manage_oddjobd,
  Boolean $pamaccess = $sssd::params::pamaccess,
  Variant[Boolean, Enum['running', 'stopped']]$service_ensure = $sssd::params::service_ensure,
  Array $service_dependencies = $sssd::params::service_dependencies,
  Array $enable_mkhomedir_flags = $sssd::params::enable_mkhomedir_flags,
  Array $disable_mkhomedir_flags = $sssd::params::disable_mkhomedir_flags,
  $ensure_absent_flags = $sssd::params::ensure_absent_flags,
) inherits sssd::params {

  anchor { 'sssd::begin': } ->
  class { '::sssd::install': } ->
  class { '::sssd::dependencies': } ->
  class { '::sssd::config': } ~>
  class { '::sssd::service': } ->
  anchor { 'sssd::end': }
}
