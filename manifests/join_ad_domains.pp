# == Defined Type: sssd::join_ad_domains
#
# Uses adcli to join to an Active Directory domain.
#
# See README.md for more details
#
define sssd::join_ad_domains ($config, $ad_join_username, $ad_join_password, $ad_join_ou) {
  $sssd_domain = $title
  $id_provider = $config["domain/${sssd_domain}"][id_provider]

  if $id_provider == 'ad' {
    if $ad_join_username == undef {
      notify {'For Active Directory join to work you must specify the ad_join_username parameter.':}
    }
    elsif $ad_join_password == undef {
      notify {'For Active Directory join to work you must specify the ad_join_password parameter.':}
    }
    elsif $ad_join_ou == undef {
      notify {'For Active Directory join to work you must specify the ad_join_ou parameter.':}
    }
    else {
      exec {'adcli_join':
        command   => "/bin/echo -n \'${ad_join_password}\' | /usr/sbin/adcli join --login-user=\'${ad_join_username}\' --domain=\'${sssd_domain}\' --domain-ou=\'${ad_join_ou}\' --stdin-password --verbose",
        logoutput => true,
        creates   => '/etc/krb5.keytab',
      }
    }
  }
}
