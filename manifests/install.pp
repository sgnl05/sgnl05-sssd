# See README.md for usage information
class sssd::install (
  $sssd_package           = $sssd::sssd_package,
  $sssd_package_ensure    = $sssd::sssd_package_ensure,
  $extra_packages         = $sssd::extra_packages,
  $extra_packages_ensure  = $sssd::extra_packages_ensure,
  $absent_packages        = $sssd::absent_packages,
  $absent_packages_ensure = $sssd::absent_packages_ensure,
) {

  ensure_resource('package', $sssd_package, { ensure => $sssd_package_ensure })

  if $extra_packages {
    ensure_packages($extra_packages,
      {
        ensure  => $extra_packages_ensure,
        require => Package[$sssd_package],
      }
    )
  }

  if $absent_packages {
    package { $absent_packages:
      ensure  => $absent_packages_ensure,
    }
  }

}
