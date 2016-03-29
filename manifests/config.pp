# See README.md for usage information
class sssd::config (
  $ensure                    = $sssd::ensure,
  $config                    = $sssd::config,
  $config_file               = $sssd::config_file,
  $mkhomedir                 = $sssd::mkhomedir,
  $enable_mkhomedir_flags    = $sssd::enable_mkhomedir_flags,
  $disable_mkhomedir_flags   = $sssd::disable_mkhomedir_flags,
  $logindefs_mail_dir        = $sssd::logindefs_mail_dir,
  $logindefs_pass_max_days   = $sssd::logindefs_pass_max_days,
  $logindefs_pass_min_days   = $sssd::logindefs_pass_min_days,
  $logindefs_pass_min_len    = $sssd::logindefs_pass_min_len,
  $logindefs_pass_warn_age   = $sssd::logindefs_pass_warn_age,
  $logindefs_uid_min         = $sssd::logindefs_uid_min,
  $logindefs_uid_max         = $sssd::logindefs_uid_max,
  $logindefs_sys_uid_min     = $sssd::logindefs_sys_uid_min,
  $logindefs_sys_uid_max     = $sssd::logindefs_sys_uid_max,
  $logindefs_gid_min         = $sssd::logindefs_gid_min,
  $logindefs_gid_max         = $sssd::logindefs_gid_max,
  $logindefs_sys_gid_min     = $sssd::logindefs_sys_gid_min,
  $logindefs_sys_gid_max     = $sssd::logindefs_sys_gid_max,
  $logindefs_create_home     = $sssd::logindefs_create_home,
  $logindefs_umask           = $sssd::logindefs_umask,
  $logindefs_usergroups_enab = $sssd::logindefs_usergroups_enab,
  $logindefs_encrypt_method  = $sssd::logindefs_encrypt_method,
  $logindefs_md5_crypt_enab  = $sssd::logindefs_md5_crypt_enab,
) {

  file { 'sssd.conf':
    ensure  => $ensure,
    path    => $config_file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template("${module_name}/sssd.conf.erb"),
  }

  case $::osfamily {

    'Redhat': {

      file { '/etc/login.defs':
        ensure  => present, # Did not use "$ensure" here since we do not want to remove this even if we are removing SSSD
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template("${module_name}/login.defs.erb"),
        notify  => Exec['authconfig-mkhomedir'], # authconfig_check_cmd does not notice when this file changes :(
      }

      $authconfig_flags = $mkhomedir ? {
        true  => join($enable_mkhomedir_flags, ' '),
        false => join($disable_mkhomedir_flags, ' '),
      }
      $authconfig_update_cmd = "/usr/sbin/authconfig ${authconfig_flags} --update"
      $authconfig_test_cmd   = "/usr/sbin/authconfig ${authconfig_flags} --test"

      # "Dummy" exec only used to notify 'authconfig-mkhomedir' if the check command is false
      exec { 'notify-authconfig':
        command => '/bin/true',
        unless  => "/usr/bin/test \"`${authconfig_test_cmd}`\" = \"`/usr/sbin/authconfig --test`\"",
        notify  => Exec['authconfig-mkhomedir'],
      }

      exec { 'authconfig-mkhomedir':
        command     => $authconfig_update_cmd,
        refreshonly => true,
      }

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
