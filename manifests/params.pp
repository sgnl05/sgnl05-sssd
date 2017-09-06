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

      case $::operatingsystem {
        default: {
          fail("operatingsystem is <${::operatingsystem}> which is not supported")
        }
        'RedHat', 'CentOS': {
          case $::operatingsystemmajrelease {
            default: {
              fail("operatingsystemrelease is <${::operatingsystemrelease}> and must be in 5, 6 or 7.")
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
          }
        }
        'Fedora': {
          case $::operatingsystemmajrelease {
            default: {
              fail("operatingsystemrelease is <${::operatingsystemrelease}> and must be in 25 or 26.")
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

    default: {
      fail("Unsupported osfamily: ${::osfamily}")
    }

  }

}
