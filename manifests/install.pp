# See README.md for usage information
class sssd::install (
  $sssd_package_ensure   = $sssd::sssd_package_ensure,
  $sssd_package          = $sssd::sssd_package,
  $extra_packages        = $sssd::extra_packages,
  $extra_packages_ensure = $sssd::extra_packages_ensure,
) {

  ensure_resource('package', $sssd_package, { ensure =>  $sssd_package_ensure })

  if $extra_packages {
    ensure_packages($extra_packages,
      { ensure => $extra_packages_ensure,
        require => Package[$sssd_package],
      }
    )
  }
}
