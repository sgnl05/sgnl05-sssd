# See README.md for usage information
class sssd::config (
  $ensure                = $sssd::ensure,
  $config                = $sssd::config,
  $sssd_package          = $sssd::sssd_package,
  $config_file           = $sssd::config_file,
  $mkhomedir             = $sssd::mkhomedir,
  $enable_mkhomedir_cmd  = $sssd::enable_mkhomedir_cmd,
  $disable_mkhomedir_cmd = $sssd::disable_mkhomedir_cmd,
  $pam_mkhomedir_check   = $sssd::pam_mkhomedir_check,
) {

  file { 'sssd.conf':
    ensure  => $ensure,
    path    => $config_file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('sssd/sssd.conf.erb'),
  }

  case $::osfamily {

    'Redhat': {

      if $mkhomedir {
        exec { 'enable mkhomedir':
          command => $enable_mkhomedir_cmd,
          unless  => $pam_mkhomedir_check,
        }
      }
      else {
        exec { 'disable mkhomedir':
          command => $disable_mkhomedir_cmd,
          onlyif  => $pam_mkhomedir_check,
        }
      }

    }

    'Debian': {

      exec { 'pam-auth-update':
        path        => '/bin:/usr/bin:/sbin:/usr/sbin',
        refreshonly => true,
      }

      file { '/usr/share/pam-configs/pam_mkhomedir':
        ensure => file,
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        source => "puppet:///modules/${module_name}/pam_mkhomedir",
        notify => Exec['pam-auth-update'],
      }

    }

    default: { }

  }

}
