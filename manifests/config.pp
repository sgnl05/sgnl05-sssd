# See README.md for usage information
class sssd::config (
  $ensure                  = $sssd::ensure,
  $config                  = $sssd::config,
  $config_file             = $sssd::config_file,
  $config_template         = $sssd::config_template,
  $mkhomedir               = $sssd::mkhomedir,
  $enable_mkhomedir_flags  = $sssd::enable_mkhomedir_flags,
  $disable_mkhomedir_flags = $sssd::disable_mkhomedir_flags,
) {

  file { 'sssd.conf':
    ensure  => $ensure,
    path    => $config_file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template($config_template),
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

    'Suse': {
      $pamconfig_mkhomedir_check_cmd  = '/usr/sbin/pam-config -q --mkhomedir | grep session:'
      $pamconfig_check_cmd            = '/usr/sbin/pam-config -q --sss | grep session:'
      $nsconfig_check_cmd             = '/usr/bin/test $( /bin/grep -cE "(passwd|group|sudoers).*sss" /etc/nsswitch.conf ) -gt 2'
      $nsconfig_cmd                   = '/bin/sed -i -e \'/^\(passwd\|group\|sudoers\):/{/sss\b/ b;s/^\(.*\)$/\1 sss/}\' /etc/nsswitch.conf'

      if $mkhomedir {

        exec { 'pam-config -a --mkhomedir':
          path        => '/bin:/usr/bin:/sbin:/usr/sbin',
          unless      => $pamconfig_mkhomedir_check_cmd,
        }

      }

      exec { 'pam-config -a --sss':
        path        => '/bin:/usr/bin:/sbin:/usr/sbin',
        unless      => $pamconfig_check_cmd,
      }

      exec { 'echo "sudoers: file sss" >> /etc/nsswitch.conf':
        path        => '/bin:/usr/bin:/sbin:/usr/sbin',
        unless      => 'grep sudoers: /etc/nsswitch.conf',
      }

      exec { "$nsconfig_cmd":
        path        => '/bin:/usr/bin:/sbin:/usr/sbin',
        unless      => $nsconfig_check_cmd,
      }

    }

    default: { }

  }

}
