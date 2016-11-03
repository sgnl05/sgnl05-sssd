# See README.md for usage information
class sssd::service (
  $sssd_service         = $sssd::sssd_service,
  $mkhomedir            = $sssd::mkhomedir,
  $manage_oddjobd       = $sssd::manage_oddjobd,
  $service_dependencies = $sssd::service_dependencies,
  $service_ensure       = $sssd::service_ensure,
) {

  if ! empty($service_dependencies) {
    ensure_resource('service', $service_dependencies,
      {
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
        enable     => true,
        before     => Service[$sssd_service],
      }
    )
  }

  ensure_resource('service', $sssd_service,
    {
      ensure     => $service_ensure,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  )

  if $mkhomedir and $manage_oddjobd {
    ensure_resource('service', 'oddjobd',
      {
        ensure     => $service_ensure,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
        require    => Service[$sssd_service],
      }
    )
  }
}
