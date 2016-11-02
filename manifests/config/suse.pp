class sssd::config::suse inherits sssd::config {

  $pamconfig_mkhomedir_check_cmd  = '/usr/sbin/pam-config -q --mkhomedir | grep session:'
  $pamconfig_check_cmd            = '/usr/sbin/pam-config -q --sss | grep session:'
  $nsconfig_check_cmd             = '/usr/bin/test $( /bin/grep -cE "(passwd|group|sudoers).*sss" /etc/nsswitch.conf ) -gt 2'
  $nsconfig_cmd                   = '/bin/sed -i -e "/^\\(passwd\\|group\\|sudoers\\):/{/sss\\b/ b;s/^\\(.*\\)$/\\1 sss/}" /etc/nsswitch.conf'

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

 if $manage_nsswitch {

    exec { 'echo "sudoers: files sss" >> /etc/nsswitch.conf':
      path        => '/bin:/usr/bin:/sbin:/usr/sbin',
      unless      => 'grep sudoers: /etc/nsswitch.conf',
    }

    exec { "$nsconfig_cmd":
      path        => '/bin:/usr/bin:/sbin:/usr/sbin',
      unless      => $nsconfig_check_cmd,
    }

  }

}
