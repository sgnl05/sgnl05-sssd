class sssd::config::redhat inherits sssd::config {
  $authconfig_flags = $mkhomedir ? {
    true  => join($::enable_mkhomedir_flags, ' '),
    false => join($::disable_mkhomedir_flags, ' '),
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
