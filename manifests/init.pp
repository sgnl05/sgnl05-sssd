# == Class: sssd
#
# Installs and configures SSSD
#
# === Parameters
#
# [*ensure*]
#   Ensure if the sssd config file is to be present or absent.
#
# [*config*]
#   Hash containing entire SSSD config.
#
# [*sssd_package*]
#   Name of the sssd package. Only set this if your platform is not supported or
#   you know what you're doing.
#
# [*sssd_package_ensure*]
#   Sets the ensure parameter of the sssd package.
#
# [*sssd_service*]
#   Name of the sssd service.
#
# [*extra_packages*]
#   Array of extra packages.
#
# [*extra_packages_ensure*]
#   String. Value of ensure parameter for extra packages.
#
# [*config_file*]
#   Path to the sssd config file.
#
# [*config_template*]
#   Defines the template used for the sssd config.
#
# [*mkhomedir*]
#   Boolean. Manage auto-creation of home directories on user login.
#
# [*manage_oddjobd*]
#   Boolean. Manage the oddjobd service.
#
# [*service_ensure*]
#   Ensure if services should be running/stopped
#
# [*service_dependencies*]
#   Array of service resource names to manage before managing sssd related
#   services. Intended to be used to manage messagebus service to prevent
#   `Error: Could not start Service[oddjobd]`.
#
# [*enable_mkhomedir_flags*]
#   Flags to use with authconfig to enable auto-creation of home directories.
#
# [*disable_mkhomedir_flags*]
#   Flags to use with authconfig to disable auto-creation of home directories.
#
class sssd (
  Enum['present', 'absent'] $ensure = 'present',
  Hash $config = {
    'sssd'               => {
      'domains'             => $::domain,
      'config_file_version' => 2,
      'services'            => ['nss', 'pam'],
    },
    "domain/${::domain}" => {
      'access_provider'    => 'simple',
      'simple_allow_users' => ['root'],
    },
  },
  String $sssd_package = 'sssd',
  String $sssd_package_ensure = 'present',
  String $sssd_service = 'sssd',
  Array $extra_packages = [],
  String $extra_packages_ensure = 'present',
  Stdlib::Absolutepath $config_file = '/etc/sssd/sssd.conf',
  Variant[Undef, String] $config_template = undef,
  Boolean $mkhomedir = true,
  Boolean $manage_oddjobd = false,
  Variant[Boolean, Enum['running', 'stopped']] $service_ensure = 'running',
  Array $service_dependencies = [],
  Array $enable_mkhomedir_flags = [
    '--enablesssd',
    '--enablesssdauth',
    '--enablemkhomedir',
  ],
  Array $disable_mkhomedir_flags = [
    '--enablesssd',
    '--enablesssdauth',
    '--disablemkhomedir',
  ],
  Array $ensure_absent_flags = [
    '--disablesssd',
    '--disablesssdauth',
  ],
) {

  # Fail on unsupported platforms
  if ($::facts['os']['family'] == 'RedHat') and !($::facts['os']['release']['major'] in ['5', '6', '7', '25', '26']) {
    fail("osfamily RedHat's os.release.major is <${::facts['os']['release']['major']}> and must be 5, 6 or 7 for EL and 25 or 26 for Fedora.")
  }

  if $::facts['os']['family'] == 'Suse' {
    if !($::facts['os']['release']['major'] in ['11', '12']) {
      fail("osfamily Suse's os.release.major is <${::facts['os']['release']['major']}> and must be 11 or 12.")
    }
    if ($::facts['os']['release']['major'] == '11') and !($::facts['os']['release']['minor'] in ['3', '4']) {
      fail("Suse 11's os.release.minor is <${::facts['os']['release']['minor']}> and must be 3 or 4.")
    }
  }

  if ($::facts['os']['family'] == 'Debian') and !($::facts['os']['release']['major'] in ['7', '8', '14', '16']) {
    fail("osfamily Debian's os.release.major is <${::facts['os']['release']['major']}> and must be 7 or 8 for Debian and 14 or 16 for Ubuntu.")
  }

  # TODO: Remove sorted hash as we no longer support ruby <= 2.1.9
  if $config_template == undef {
    if versioncmp($::rubyversion, '1.9.3') >= 0 {
      $cfg_template = 'sssd/sssd.conf.erb'
    } else {
      $cfg_template = 'sssd/sssd.conf.sorted.erb'
    }
  } else {
    $cfg_template = $config_template
  }

  ensure_packages($sssd_package,
    {
      ensure => $sssd_package_ensure,
      before => File['sssd.conf'],
    }
  )

  if $extra_packages {
    ensure_packages($extra_packages,
      {
        ensure  => $extra_packages_ensure,
        require => Package[$sssd_package],
      }
    )
  }

  if $manage_oddjobd == true {
    $before = 'Service[oddjobd]'
  } else {
    $before = undef
  }

  if ! empty($service_dependencies) {
    ensure_resource('service', $service_dependencies,
      {
        ensure     => running,
        hasstatus  => true,
        hasrestart => true,
        enable     => true,
        before     => $before,
      }
    )
  }

  if $mkhomedir and $manage_oddjobd {
    ensure_resource('service', 'oddjobd',
      {
        ensure     => $service_ensure,
        enable     => true,
        hasstatus  => true,
        hasrestart => true,
      }
    )
  }

  $file_ensure = $ensure ? {
    'present' => 'file',
    default   => $ensure,
  }

  file { 'sssd.conf':
    ensure  => $file_ensure,
    path    => $config_file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template($cfg_template),
  }

  case $::osfamily {
    'RedHat': {
      if $ensure == 'present' {
        $authconfig_flags = $mkhomedir ? {
          true  => join($enable_mkhomedir_flags, ' '),
          false => join($disable_mkhomedir_flags, ' '),
        }
      }
      else {
        $authconfig_flags = join($ensure_absent_flags, ' ')
      }

      $authconfig_update_cmd = "/usr/sbin/authconfig ${authconfig_flags} --update"
      $authconfig_test_cmd   = "/usr/sbin/authconfig ${authconfig_flags} --test"
      $authconfig_check_cmd  = "/usr/bin/test \"`${authconfig_test_cmd}`\" = \"`/usr/sbin/authconfig --test`\""

      exec { 'authconfig-mkhomedir':
        command => $authconfig_update_cmd,
        unless  => $authconfig_check_cmd,
        require => File['sssd.conf'],
      }
    }
    'Debian': {
      if $mkhomedir {
        file { '/usr/share/pam-configs/pam_mkhomedir':
          ensure => 'file',
          owner  => 'root',
          group  => 'root',
          mode   => '0644',
          source => 'puppet:///modules/sssd/pam_mkhomedir',
          notify => Exec['pam-auth-update'],
        }

        exec { 'pam-auth-update':
          path        => '/bin:/usr/bin:/sbin:/usr/sbin',
          refreshonly => true,
        }
      }
    }
    'Suse': {
      $pamconfig_mkhomedir_check_cmd  = '/usr/sbin/pam-config -q --mkhomedir | grep session:'
      $pamconfig_check_cmd  = '/usr/sbin/pam-config -q --sss | grep session:'

      if $mkhomedir {

        exec { 'pam-config -a --mkhomedir':
          path   => '/bin:/usr/bin:/sbin:/usr/sbin',
          unless => $pamconfig_mkhomedir_check_cmd,
        }
      }

      exec { 'pam-config -a --sss':
        path   => '/bin:/usr/bin:/sbin:/usr/sbin',
        unless => $pamconfig_check_cmd,
      }
    }
    default: { }
  }

  $service_ensure_real = $sssd::ensure ? {
    'absent' => 'stopped',
    default  => $sssd::service_ensure,
  }

  $service_enable = $service_ensure ? {
    'stopped' => false,
    default   => true,
  }

  ensure_resource('service', $sssd_service,
    {
      ensure     => $service_ensure_real,
      enable     => $service_enable,
      hasstatus  => true,
      hasrestart => true,
      subscribe  => File['sssd.conf'],
    }
  )
}
