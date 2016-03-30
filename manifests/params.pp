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

  # Earlier versions of ruby didn't provide ordered hashs, so we need to sort
  # the configuration ourselves to ensure a consistent config file.
  if versioncmp($::rubyversion, '1.9.3') >= 0 {
    $config_template = "${module_name}/sssd.conf.erb"
  } else {
    $config_template = "${module_name}/sssd.conf.sorted.erb"
  }

  case $::osfamily {

    'RedHat': {

      $sssd_package   = 'sssd'
      $sssd_service   = 'sssd'
      $service_ensure = 'running'
      $config_file    = '/etc/sssd/sssd.conf'
      $mkhomedir      = true

      if versioncmp($::operatingsystemrelease, '6.0') < 0 {
        $extra_packages = [
          'authconfig',
        ]
        $extra_packages_ensure = 'latest'
        $manage_oddjobd        = false
      } else {
        $extra_packages = [
          'authconfig',
          'oddjob-mkhomedir',
        ]
        $extra_packages_ensure = 'present'
        $manage_oddjobd        = true
      }

      # Default variables for /etc/login.defs
      $logindefs_mail_dir        = '/var/spool/mail'
      $logindefs_pass_max_days   = '99999'
      $logindefs_pass_min_days   = '0'
      $logindefs_pass_min_len    = '5'
      $logindefs_pass_warn_age   = '7'
      # Default values for user vs system UID/GID changed with RHEL/CentOS 7
      if versioncmp($::operatingsystemrelease, '7.0') < 0 {
        $logindefs_uid_min         = '500'
        $logindefs_uid_max         = '60000'
        $logindefs_sys_uid_min     = '201'
        $logindefs_sys_uid_max     = '499'
        $logindefs_gid_min         = '500'
        $logindefs_gid_max         = '60000'
        $logindefs_sys_gid_min     = '201'
        $logindefs_sys_gid_max     = '499'
      } else {
        $logindefs_uid_min         = '1000'
        $logindefs_uid_max         = '60000'
        $logindefs_sys_uid_min     = '201'
        $logindefs_sys_uid_max     = '999'
        $logindefs_gid_min         = '1000'
        $logindefs_gid_max         = '60000'
        $logindefs_sys_gid_min     = '201'
        $logindefs_sys_gid_max     = '999'
      }
      $logindefs_create_home     = 'yes'
      $logindefs_umask           = '077'
      $logindefs_usergroups_enab = 'yes'
      $logindefs_encrypt_method  = 'MD5'
      $logindefs_md5_crypt_enab  = 'yes'

    }

    'Debian': {

      $sssd_package   = 'sssd'
      $sssd_service   = 'sssd'
      $service_ensure = 'running'
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
