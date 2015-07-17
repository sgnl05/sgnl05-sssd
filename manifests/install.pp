# See README.md for usage information
class sssd::install (
  $ensure         = $sssd::ensure,
  $sssd_package   = $sssd::sssd_package,
  $extra_packages = $sssd::extra_packages,
) {

  package { $sssd_package:
    ensure => $ensure,
  }

  if $extra_packages {
    package { $extra_packages:
      ensure  => $ensure,
      require => Package[$sssd_package],
    }
  }

}
