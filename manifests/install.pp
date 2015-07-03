# See README.md for usage information
class sssd::install (
  $ensure         = $sssd::params::ensure,
  $sssd_package   = $sssd::params::sssd_package,
  $extra_packages = $sssd::params::extra_packages,
) inherits sssd::params {

  package { $sssd_package :
    ensure => $ensure,
  }

  if $extra_packages {
    package { $extra_packages :
      ensure  => $ensure,
      require => Package[$sssd_package],
    }
  }

}
