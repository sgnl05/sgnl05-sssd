# See README.md for usage information
class sssd::service (
  $sssd_service         = $sssd::sssd_service,
  $service_ensure       = $sssd::ensure ? {
    absent      => 'stopped',
    default     => $sssd::service_ensure,
    }
) {

  $service_enable = $service_ensure ? {
      stopped    => false,
      default   => true,
  }
  ensure_resource('service', $sssd_service,
    {
      ensure     => $service_ensure,
      enable     => $service_enable,
      hasstatus  => true,
      hasrestart => true,
    }
  )
}
