# See README.md for usage information
class sssd::config (
  $ensure                = $sssd::params::ensure,
  $config                = $sssd::params::config,
  $sssd_package          = $sssd::params::sssd_package,
  $config_file           = $sssd::params::config_file,
  $mkhomedir             = $sssd::params::mkhomedir,
  $enable_mkhomedir_cmd  = $sssd::params::enable_mkhomedir_cmd,
  $disable_mkhomedir_cmd = $sssd::params::disable_mkhomedir_cmd,
  $pam_mkhomedir_check   = $sssd::params::pam_mkhomedir_check,
) inherits sssd::params {

  file { 'sssd.conf':
    ensure  => $ensure,
    path    => $config_file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    notify  => Class['sssd::service'],
    content => template('sssd/sssd.conf.erb'),
  }

  case $::osfamily {

    'Redhat': {

      if $mkhomedir {
        exec {'enable mkhomedir':
          command => $enable_mkhomedir_cmd,
          unless  => $pam_mkhomedir_check,
          require => [
            Package['authconfig'],
            Package['oddjob-mkhomedir'],
          ],
        }
      }
      else {
        exec {'disable mkhomedir':
          command => $disable_mkhomedir_cmd,
          onlyif  => $pam_mkhomedir_check,
          require => Package['authconfig'],
        }
      }

    }

    'Debian': {

      exec { 'pam-auth-update':
        path        => '/bin:/usr/bin:/sbin:/usr/sbin',
        refreshonly => true,
        require     => Package['libpam-runtime'],
      }

      file { '/usr/share/pam-configs/pam_mkhomedir':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/sssd/pam_mkhomedir',
        require => Package['libpam-runtime'],
        notify  => Exec['pam-auth-update'],
      }

    }

    default: { }

  }

}
