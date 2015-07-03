# See README.md for usage information
class sssd::service (
  $sssd_service = $sssd::params::sssd_service,
  $mkhomedir    = $sssd::params::mkhomedir,
) {

  service { $sssd_service :
    ensure  => running,
    enable  => true,
    require => File['sssd.conf'],
  }

  if $mkhomedir {

    service { 'oddjobd':
      ensure  => running,
      enable  => true,
      require => Service[$sssd_service],
    }

  }

}
