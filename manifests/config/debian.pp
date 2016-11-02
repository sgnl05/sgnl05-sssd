class sssd::config::debian inherits sssd::config {
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
