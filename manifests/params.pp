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
  $ensure_absent_flags = ['--disablesssd', '--disablesssdauth']

  # Earlier versions of ruby didn't provide ordered hashs, so we need to sort
  # the configuration ourselves to ensure a consistent config file.
  if versioncmp($::rubyversion, '1.9.3') >= 0 {
    $config_template = "${module_name}/sssd.conf.erb"
  } else {
    $config_template = "${module_name}/sssd.conf.sorted.erb"
  }

  $sssd_package_ensure = 'present'

  case $::osfamily {

    'RedHat': {

      $sssd_package         = 'sssd'
      $sssd_service         = 'sssd'
      $service_ensure       = 'running'
      $config_file          = '/etc/sssd/sssd.conf'
      $mkhomedir            = true

      case $::operatingsystemmajrelease {
        default: {
          fail("operatingsystemrelease is <${::operatingsystemrelease}> and must be in 5, 6 or 7 for EL and 25 or 26 for Fedora.")
        }
        '5': {
          $service_dependencies = ['messagebus']
          $extra_packages = [
            'authconfig',
          ]
          $extra_packages_ensure = 'latest'
          $manage_oddjobd        = false
        }
        '6': {
          $service_dependencies = ['messagebus']
          $extra_packages = [
            'authconfig',
            'oddjob-mkhomedir',
          ]
          $extra_packages_ensure = 'present'
          $manage_oddjobd        = true
        }
        '7': {
          $service_dependencies = []
          $extra_packages = [
            'authconfig',
            'oddjob-mkhomedir',
          ]
          $extra_packages_ensure = 'present'
          $manage_oddjobd        = true
        }
        '25', '26': {
          $service_dependencies = []
          $extra_packages = [
            'authconfig',
            'oddjob-mkhomedir',
          ]
          $extra_packages_ensure = 'present'
          $manage_oddjobd        = true
        }
      }
    }

    'Debian': {

      $sssd_package   = 'sssd'
      $sssd_service   = 'sssd'
      $service_ensure = 'running'
      $service_dependencies = []
      $config_file    = '/etc/sssd/sssd.conf'
      $mkhomedir      = true
      $extra_packages = [
        'libpam-runtime',
        'libpam-sss',
        'libnss-sss',
      ]
      $extra_packages_ensure = 'present'
      $manage_oddjobd        = false
    }

    'Suse': {

      $sssd_package   = 'sssd'
      $sssd_service   = 'sssd'
      $service_ensure = 'running'
      $config_file    = '/etc/sssd/sssd.conf'
      $mkhomedir      = true
      #case $::operatingsystemrelease {
      case $::operatingsystemmajrelease {
        default: {
          fail("operatingsystemrelease is <${::operatingsystemmajrelease}> and must be in 11 or 12.")
        }
        '11': {
          case $::operatingsystemrelease {
            default: {
              fail("operatingsystemrelease is <${::operatingsystemrelease}> and must be in 11.3 or 11.4.")
            }
            /^11.[34]/: {
              $service_dependencies = []
              $extra_packages = [
                'sssd-32bit',
                'sssd-tools',
              ]
              $extra_packages_ensure = 'present'
              $manage_oddjobd        = false
            }
          }
        }
        '12': {
          $service_dependencies = []
          $extra_packages = [
            'sssd-krb5',
            'sssd-ad',
            'sssd-ipa',
            'sssd-32bit',
            'sssd-tools',
            'sssd-ldap',
          ]
          $extra_packages_ensure = 'present'
          $manage_oddjobd        = false
        }
      }
    }

    'Gentoo': {

      $sssd_package   = 'sssd'
      $sssd_service   = 'sssd'
      $service_ensure = 'running'
      $service_dependencies = []
      $config_file    = '/etc/sssd/sssd.conf'
      $mkhomedir      = true
      $extra_packages = []
      $extra_packages_ensure = 'present'
      $manage_oddjobd        = false
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}")
    }

  }

}
