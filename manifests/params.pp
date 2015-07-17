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

  case $::osfamily {

    'RedHat': {

      $sssd_package = 'sssd'
      $sssd_service = 'sssd'
      $config_file  = '/etc/sssd/sssd.conf'
      $mkhomedir    = true

      if versioncmp($::operatingsystemrelease, '6.0') < 0 {
        $extra_packages = [
          'authconfig'
        ]
        $manage_oddjobd = false
      } else {
        $extra_packages = [
          'authconfig',
          'oddjob-mkhomedir'
        ]
        $manage_oddjobd = true
      }

    }

    'Debian': {

      $sssd_package   = 'sssd'
      $sssd_service   = 'sssd'
      $config_file    = '/etc/sssd/sssd.conf'
      $mkhomedir      = true
      $extra_packages = [
        'libpam-runtime',
        'libpam-sss',
        'libnss-sss',
      ]
      $manage_oddjobd = false

    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}")
    }

  }

}
