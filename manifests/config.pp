# See README.md for usage information
class sssd::config (
  $ensure                  = $sssd::ensure,
  $config                  = $sssd::config,
  $config_file             = $sssd::config_file,
  $config_template         = $sssd::config_template,
  $mkhomedir               = $sssd::mkhomedir,
  $enable_mkhomedir_flags  = $sssd::enable_mkhomedir_flags,
  $disable_mkhomedir_flags = $sssd::disable_mkhomedir_flags,
  $ad_join_username        = $sssd::ad_join_username,
  $ad_join_password        = $sssd::ad_join_password,
  $ad_join_ou              = $sssd::ad_join_ou,
) {

  file { 'sssd.conf':
    ensure  => $ensure,
    path    => $config_file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template($config_template),
  }

  $sssd_domains = $config[sssd][domains]

  sssd::join_ad_domains { $sssd_domains:
    config           => $config,
    ad_join_username => $ad_join_username,
    ad_join_password => $ad_join_password,
    ad_join_ou       => $ad_join_ou,
  }

  case $::osfamily {

    'Redhat': {

      $authconfig_flags = $mkhomedir ? {
        true  => join($enable_mkhomedir_flags, ' '),
        false => join($disable_mkhomedir_flags, ' '),
      }
      $authconfig_update_cmd = "/usr/sbin/authconfig ${authconfig_flags} --update"
      $authconfig_test_cmd   = "/usr/sbin/authconfig ${authconfig_flags} --test"
      $authconfig_check_cmd  = "/usr/bin/test \"`${authconfig_test_cmd}`\" = \"`/usr/sbin/authconfig --test`\""

      exec { 'authconfig-mkhomedir':
        command => $authconfig_update_cmd,
        unless  => $authconfig_check_cmd,
      }
      Exec[ 'authconfig-mkhomedir' ] -> File[ 'sssd.conf' ]
    }

    'Debian': {

      if $mkhomedir {

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

    }

    default: { }

  }

}
