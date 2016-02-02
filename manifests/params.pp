# Default parameters
class sssd::params {

  $ensure = 'present'
  $config = {
    'sssd' => {
      'config_file_version' => '2',
      'services'            => 'nss, pam',
      'domains'             => 'ad.example.com',
    },
    'domain/ad.example.com' => {
      'id_provider'       => 'ad',
      'krb5_realm'        => 'AD.EXAMPLE.COM',
      'cache_credentials' => true,
    },
  }
  $enable_mkhomedir_flags  = ['--enablesssd', '--enablesssdauth', '--enablemkhomedir']
  $disable_mkhomedir_flags = ['--enablesssd', '--enablesssdauth', '--disablemkhomedir']

  # Earlier versions of ruby didn't provide ordered hashs, so we need to sort
  # the configuration ourselves to ensure a consistent config file.
  if versioncmp($::rubyversion, '1.9.3') >= 0 {
    $config_template = "${module_name}/sssd.conf.erb"
  } else {
    $config_template = "${module_name}/sssd.conf.sorted.erb"
  }

  $ad_join_username = undef
  $ad_join_password = undef
  $ad_join_ou       = undef

  case $::osfamily {

    'RedHat': {

      $sssd_package   = 'sssd'
      $sssd_service   = 'sssd'
      $service_ensure = 'running'
      $config_file    = '/etc/sssd/sssd.conf'
      $mkhomedir      = true

      if versioncmp($::operatingsystemrelease, '6.0') < 0 {
        $extra_packages = [
          'authconfig',
        ]
        $extra_packages_ensure = 'latest'
        $manage_oddjobd        = false
      } else {
        $extra_packages = [
          'authconfig',
          'oddjob-mkhomedir',
          'adcli',
        ]
        $extra_packages_ensure = 'present'
        $manage_oddjobd        = true
      }

    }

    'Debian': {

      $sssd_package   = 'sssd'
      $sssd_service   = 'sssd'
      $service_ensure = 'running'
      $config_file    = '/etc/sssd/sssd.conf'
      $mkhomedir      = true
      $extra_packages = [
        'libpam-runtime',
        'libpam-sss',
        'libnss-sss',
        'adcli',
      ]
      $extra_packages_ensure = 'present'
      $manage_oddjobd        = false

    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}")
    }

  }

}
