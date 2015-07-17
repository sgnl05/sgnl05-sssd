# See README.md for usage information
class sssd::service (
  $sssd_service = $sssd::sssd_service,
  $mkhomedir    = $sssd::mkhomedir,
) {

  service { $sssd_service:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }

  if $mkhomedir {

    service { 'oddjobd':
      ensure     => running,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
      require    => Service[$sssd_service],
    }

  }

}
