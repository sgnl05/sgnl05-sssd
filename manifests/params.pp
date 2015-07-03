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
  $enable_mkhomedir_cmd  = '/usr/sbin/authconfig --enablesssd --enablesssdauth --enablemkhomedir --update'
  $disable_mkhomedir_cmd = '/usr/sbin/authconfig --enablesssd --enablesssdauth --disablemkhomedir --update'
  $pam_mkhomedir_check   = '/bin/grep -E \'^USEMKHOMEDIR=yes$\' /etc/sysconfig/authconfig'

  case $::osfamily {

    'Redhat': {

      $sssd_package   = 'sssd'
      $sssd_service   = 'sssd'
      $config_file    = '/etc/sssd/sssd.conf'
      $mkhomedir      = true
      $extra_packages = [
        'authconfig',
        'oddjob-mkhomedir'
      ]

    }

    'Debian': {

      $sssd_package   = 'sssd'
      $sssd_service   = 'sssd'
      $config_file    = '/etc/sssd/sssd.conf'
      $mkhomedir      = false
      $extra_packages = [
        'libpam-runtime',
        'libpam-sss',
        'libnss-sss',
      ]

    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}")
    }

  }

}
