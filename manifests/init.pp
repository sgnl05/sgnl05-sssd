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
  $ensure                  = $sssd::params::ensure,
  $config                  = $sssd::params::config,
  $sssd_package            = $sssd::params::sssd_package,
  $sssd_package_ensure     = $sssd::params::sssd_package_ensure,
  $sssd_service            = $sssd::params::sssd_service,
  $extra_packages          = $sssd::params::extra_packages,
  $extra_packages_ensure   = $sssd::params::extra_packages_ensure,
  $config_file             = $sssd::params::config_file,
  $config_template         = $sssd::params::config_template,
  $mkhomedir               = $sssd::params::mkhomedir,
  $manage_oddjobd          = $sssd::params::manage_oddjobd,
  $pamaccess               = $sssd::params::pamaccess,
  $service_ensure          = $sssd::params::service_ensure,
  $service_dependencies    = $sssd::params::service_dependencies,
  $enable_mkhomedir_flags  = $sssd::params::enable_mkhomedir_flags,
  $disable_mkhomedir_flags = $sssd::params::disable_mkhomedir_flags,
) inherits sssd::params {

  validate_re($ensure, '^(present|absent)$',
  "${ensure} is not supported for ensure.
  Allowed values are 'present' and 'absent'.")

  validate_string(
    $sssd_package_ensure,
    $sssd_package,
    $sssd_service,
    $config_template
  )

  validate_array(
    $extra_packages,
    $enable_mkhomedir_flags,
    $disable_mkhomedir_flags,
    $service_dependencies
  )

  validate_absolute_path(
    $config_file
  )

  validate_bool(
    $mkhomedir,
    $pamaccess
  )

  validate_hash(
    $config
  )

  validate_re($service_ensure, '^running|true|stopped|false$')

  anchor { 'sssd::begin': } ->
  class { '::sssd::install': } ->
  class { '::sssd::dependencies': } ->
  class { '::sssd::config': } ~>
  class { '::sssd::service': } ->
  anchor { 'sssd::end': }

}
