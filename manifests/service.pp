# See README.md for usage information
class sssd::service (
  $sssd_service         = $sssd::sssd_service,
  $service_ensure       = $sssd::service_ensure,
) {

  ensure_resource('service', $sssd_service,
    {
      ensure     => $service_ensure,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  )
}
