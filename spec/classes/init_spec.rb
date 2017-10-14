require 'spec_helper'
describe 'sssd' do
  platforms = {
    'debian7' => {
      :extra_packages => [
        'libpam-runtime',
        'libpam-sss',
        'libnss-sss',
      ],
      :manage_oddjobd => false,
      :facts_hash => {
        :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :operatingsystemrelease => '7.1',
        :operatingsystemmajrelease => '7',
        :rubyversion => '1.9.3',
        :os => {
          'family' => 'Debian',
          'release' => {
            'major' => '7',
          },
        },
      },
    },
    'debian8' => {
      :extra_packages => [
        'libpam-runtime',
        'libpam-sss',
        'libnss-sss',
      ],
      :manage_oddjobd => false,
      :facts_hash => {
        :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :operatingsystemrelease => '8.1',
        :operatingsystemmajrelease => '8',
        :rubyversion => '1.9.3',
        :os => {
          'family' => 'Debian',
          'release' => {
            'major' => '8',
          },
        },
      },
    },
    'el5' => {
      :extra_packages => ['authconfig'],
      :service_dependencies => ['messagebus'],
      :manage_oddjobd => false,
      :facts_hash => {
        :osfamily => 'RedHat',
        :operatingsystem => 'RedHat',
        :operatingsystemmajrelease => '5',
        :os => {
          'family' => 'RedHat',
          'release' => {
            'major' => '5',
          },
        },
        :rubyversion => '1.9.3',
      },
    },
    'el6' => {
      :extra_packages => [
        'authconfig',
        'oddjob-mkhomedir',
      ],
      :service_dependencies => ['messagebus'],
      :manage_oddjobd => true,
      :facts_hash => {
        :osfamily => 'RedHat',
        :operatingsystem => 'RedHat',
        :operatingsystemmajrelease => '6',
        :os => {
          'family' => 'RedHat',
          'release' => {
            'major' => '6',
          },
        },
        :rubyversion => '1.9.3',
      },
    },
    'el7' => {
      :extra_packages => [
        'authconfig',
        'oddjob-mkhomedir',
      ],
      :manage_oddjobd => true,
      :facts_hash => {
        :osfamily => 'RedHat',
        :operatingsystem => 'RedHat',
        :operatingsystemmajrelease => '7',
        :os => {
          'family' => 'RedHat',
          'release' => {
            'major' => '7',
          },
        },
        :rubyversion => '1.9.3',
      },
    },
    'fedora25' => {
      :extra_packages => [
        'authconfig',
        'oddjob-mkhomedir',
      ],
      :manage_oddjobd => true,
      :facts_hash => {
        :osfamily => 'RedHat',
        :operatingsystem => 'RedHat',
        :operatingsystemmajrelease => '25',
        :os => {
          'family' => 'RedHat',
          'release' => {
            'major' => '25',
          },
        },
        :rubyversion => '1.9.3',
      },
    },
    'fedora26' => {
      :extra_packages => [
        'authconfig',
        'oddjob-mkhomedir',
      ],
      :manage_oddjobd => true,
      :facts_hash => {
        :osfamily => 'RedHat',
        :operatingsystem => 'RedHat',
        :operatingsystemmajrelease => '26',
        :os => {
          'family' => 'RedHat',
          'release' => {
            'major' => '26',
          },
        },
        :rubyversion => '1.9.3',
      },
    },
    'suse11_3' => {
      :extra_packages => [
        'sssd-32bit',
        'sssd-tools',
      ],
      :facts_hash => {
        :osfamily => 'Suse',
        :operatingsystem => 'SLES',
        :operatingsystemrelease => '11.3',
        :operatingsystemmajrelease => '11',
        :rubyversion => '2.1.9',
        :os => {
          'family' => 'Suse',
          'release' => {
            'major' => '11',
            'minor' => '3',
          },
        },
      },
    },
    'suse11_4' => {
      :extra_packages => [
        'sssd-32bit',
        'sssd-tools',
      ],
      :facts_hash => {
        :osfamily => 'Suse',
        :operatingsystem => 'SLES',
        :operatingsystemrelease => '11.4',
        :operatingsystemmajrelease => '11',
        :rubyversion => '2.1.9',
        :os => {
          'family' => 'Suse',
          'release' => {
            'major' => '11',
            'minor' => '4',
          },
        },
      },
    },
    'suse12' => {
      :extra_packages => [
        'sssd-krb5',
        'sssd-ad',
        'sssd-ipa',
        'sssd-32bit',
        'sssd-tools',
        'sssd-ldap',
      ],
      :facts_hash => {
        :osfamily => 'Suse',
        :operatingsystem => 'SLES',
        :operatingsystemrelease => '12.1',
        :operatingsystemmajrelease => '12',
        :rubyversion => '2.1.9',
        :os => {
          'family' => 'Suse',
          'release' => {
            'major' => '12',
          },
        },
      },
    },
    'ubuntu14' => {
      :extra_packages => [
        'libpam-runtime',
        'libpam-sss',
        'libnss-sss',
      ],
      :facts_hash => {
        :osfamily => 'Debian',
        :operatingsystem => 'Ubuntu',
        :operatingsystemrelease => '14.04',
        :operatingsystemmajrelease => '14',
        :rubyversion => '1.9.3',
        :os => {
          'family' => 'Debian',
          'release' => {
            'major' => '14',
          },
        },
      },
    },
    'ubuntu16' => {
      :extra_packages => [
        'libpam-runtime',
        'libpam-sss',
        'libnss-sss',
      ],
      :facts_hash => {
        :osfamily => 'Debian',
        :operatingsystem => 'Ubuntu',
        :operatingsystemrelease => '16.04',
        :operatingsystemmajrelease => '16',
        :rubyversion => '1.9.3',
        :os => {
          'family' => 'Debian',
          'release' => {
            'major' => '16',
          },
        },
      },
    },
  }

  describe 'with default values for parameters on' do
    platforms.sort.each do |k,v|
      context "#{k}" do
        let(:facts) do
          v[:facts_hash]
        end

        it { should compile.with_all_deps }
        it { should contain_class('sssd')}

        it do
          should contain_package('sssd').with({
            :ensure => 'present',
            :before => 'File[sssd.conf]',
          })
        end

        it do
          should contain_file('sssd.conf').with({
            :ensure => 'file',
            :path   => '/etc/sssd/sssd.conf',
            :owner  => 'root',
            :group  => 'root',
            :mode   => '0600',
            :content => /^# Managed by Puppet.\n\n\[sssd\]/
          })
        end

        it do
          should contain_service('sssd').with({
            :ensure     => 'running',
            :enable     => true,
            :hasstatus  => true,
            :hasrestart => true,
            :subscribe  => 'File[sssd.conf]',
          })
        end

        if v[:extra_packages]
          v[:extra_packages].each do |pkg|
            it do
              should contain_package(pkg).with({
                :ensure => 'present',
                :require => 'Package[sssd]',
              })
            end
          end
        end

        if v[:manage_oddjobd] == true
          it do
            should contain_service('oddjobd').with({
              :ensure     => 'running',
              :enable     => true,
              :hasstatus  => true,
              :hasrestart => true,
            })
          end
        end

        if v[:service_dependencies] and v[:manage_oddjobd] == true
          v[:service_dependencies].each do |svc|
            it do
              should contain_service(svc).with({
                :ensure     => 'running',
                :hasstatus  => true,
                :hasrestart => true,
                :enable     => true,
                :before     => 'Service[oddjobd]',
              })
            end
          end
        end

        if v[:facts_hash][:osfamily] == 'Debian'
          it do
            should contain_file('/usr/share/pam-configs/pam_mkhomedir').with({
              :ensure => 'file',
              :owner  => 'root',
              :group  => 'root',
              :mode   => '0644',
              :source => "puppet:///modules/sssd/pam_mkhomedir",
              :notify => 'Exec[pam-auth-update]',
            })
          end

          it do
            should contain_exec('pam-auth-update').with({
              :path        => '/bin:/usr/bin:/sbin:/usr/sbin',
              :refreshonly => true,
            })
          end
        end

        if v[:facts_hash][:osfamily] == 'RedHat'
          it do
            should contain_exec('authconfig-mkhomedir').with({
              :command => '/usr/sbin/authconfig --enablesssd --enablesssdauth --enablemkhomedir --update',
              :unless => "/usr/bin/test \"`/usr/sbin/authconfig --enablesssd --enablesssdauth --enablemkhomedir --test`\" = \"`/usr/sbin/authconfig --test`\"",
              :require => 'File[sssd.conf]',
            })
          end
        end

        if v[:facts_hash][:osfamily] == 'Suse'
          it do
            should contain_exec('pam-config -a --mkhomedir').with({
              :path   => '/bin:/usr/bin:/sbin:/usr/sbin',
              :unless => '/usr/sbin/pam-config -q --mkhomedir | grep session:',
            })
          end

          it do
            should contain_exec('pam-config -a --sss').with({
              :path   => '/bin:/usr/bin:/sbin:/usr/sbin',
              :unless => '/usr/sbin/pam-config -q --sss | grep session:',
            })
          end
        end
      end
    end
  end

  describe 'on unsupported version of' do
    context 'Debian (not 7 our 8 or Ubuntu 14 or 16)' do
      let(:facts) do
        {
          :osfamily => 'Debian',
          :operatingsystem => 'Debian',
          :operatingsystemmajrelease => '6',
          :os => {
            'family' => 'Debian',
            'release' => {
              'major' => '6',
            }
          },
          :rubyversion => '1.9.3',
        }
      end

      it 'unsupported Debian / Ubuntu should fail' do
        expect do
          should contain_class('sssd')
        end.to raise_error(Puppet::Error, /osfamily Debian's os\.release\.major is <6> and must be 7 or 8 for Debian and 14 or 16 for Ubuntu/)
      end
    end
    context 'RedHat (not 5, 6 or 7 or Fedora 25 or 26)' do
      let(:facts) do
        {
          :osfamily => 'RedHat',
          :operatingsystem => 'RedHat',
          :operatingsystemmajrelease => '4',
          :os => {
            'family' => 'RedHat',
            'release' => {
              'major' => '4',
            }
          },
          :rubyversion => '1.9.3',
        }
      end

      it 'unsupported EL should fail' do
        expect do
          should contain_class('sssd')
        end.to raise_error(Puppet::Error, /osfamily RedHat's os\.release\.major is <4> and must be 5, 6 or 7 for EL and 25 or 26 for Fedora/)
      end
    end

    context 'Suse (not 11 or 12)' do
      let(:facts) do
        {
          :osfamily => 'Suse',
          :operatingsystem => 'Suse',
          :operatingsystemmajrelease => '10',
          :os => {
            'family' => 'Suse',
            'release' => {
              'major' => '10',
              'minor' => '0',
            }
          },
          :rubyversion => '1.9.3',
        }
      end

      it 'unsupported Suse should fail' do
        expect do
          should contain_class('sssd')
        end.to raise_error(Puppet::Error, /osfamily Suse's os\.release\.major is <10> and must be 11 or 12/)
      end
    end

    context 'Suse 11 (not 11.3 and 11.4)' do
      let(:facts) do
        {
          :osfamily => 'Suse',
          :operatingsystem => 'Suse',
          :operatingsystemmajrelease => '11',
          :operatingsystemrelease => '11.1',
          :os => {
            'family' => 'Suse',
            'release' => {
              'major' => '11',
              'minor' => '1',
            },
          },
          :rubyversion => '1.9.3',
        }
      end

      it 'unsupported Suse 11 should fail' do
        expect do
          should contain_class('sssd')
        end.to raise_error(Puppet::Error, /Suse 11's os\.release\.minor is <1> and must be 3 or 4/)
      end
    end
  end

  describe 'on RedHat 5' do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :operatingsystem => 'RedHat',
        :operatingsystemmajrelease => '5',
        :os => {
          'family' => 'RedHat',
          'release' => {
            'major' => '5',
          },
        },
        :rubyversion => '1.9.3',
      }
    end

    context 'with defaults for all parameters' do

      it { is_expected.not_to contain_package('oddjob-mkhomedir') }
      it { is_expected.not_to contain_service('oddjobd') }

      it { is_expected.to contain_service('messagebus').with_ensure('running') }
    end

    context 'with service ensure stopped' do
      let(:params) { { :service_ensure => 'stopped' } }
      it { is_expected.to contain_service('sssd').with_ensure('stopped') }
    end

    context 'with ruby without ordered hashes' do
      let(:facts) do
        {
          :osfamily => 'RedHat',
          :operatingsystem => 'RedHat',
          :operatingsystemrelease => '5.7',
          :operatingsystemmajrelease => '5',
          :rubyversion => '1.8.7',
          :os => {
            'family' => 'RedHat',
            'release' => {
              'major' => '5',
            },
          },
        }
      end
    end
  end


  describe 'on RedHat 6' do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :operatingsystem => 'RedHat',
        :operatingsystemrelease => '6.6',
        :operatingsystemmajrelease => '6',
        :rubyversion => '1.9.3',
        :os => {
          'family' => 'RedHat',
          'release' => {
            'major' => '6',
          },
        },
      }
    end

    context 'with defaults for all parameters' do
      it { is_expected.to contain_service('oddjobd') }

      it { is_expected.to contain_service('oddjobd').with_ensure('running') }
      it { is_expected.to contain_service('messagebus').with_ensure('running') }
    end

    context 'with service ensure stopped' do
      let(:params) { { :service_ensure => 'stopped' } }
      it { is_expected.to contain_service('sssd').with_ensure('stopped') }
      it { is_expected.to contain_service('oddjobd').with_ensure('stopped') }
    end

    context 'with ruby without ordered hashes' do
      let(:facts) do
        {
          :osfamily => 'RedHat',
          :operatingsystem => 'RedHat',
          :operatingsystemrelease => '6.6',
          :operatingsystemmajrelease => '6',
          :rubyversion => '1.8.7',
          :os => {
            'family' => 'RedHat',
            'release' => {
              'major' => '6',
            },
          },
        }
      end
    end
  end

  describe 'on RedHat 7' do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :operatingsystem => 'RedHat',
        :operatingsystemrelease => '7.1',
        :operatingsystemmajrelease => '7',
        :rubyversion => '1.9.3',
        :os => {
          'family' => 'RedHat',
          'release' => {
            'major' => '7',
          },
        },
      }
    end

    context 'with defaults for all parameters' do
      it { is_expected.to contain_service('oddjobd') }

      it { is_expected.to contain_service('oddjobd').with_ensure('running') }
      it { is_expected.not_to contain_service('messagebus') }
    end

    context 'with service ensure stopped' do
      let(:params) { { :service_ensure => 'stopped' } }
      it { is_expected.to contain_service('sssd').with_ensure('stopped') }
      it { is_expected.to contain_service('oddjobd').with_ensure('stopped') }
    end

    context 'with ruby without ordered hashes' do
      let(:facts) do
        {
          :osfamily => 'RedHat',
          :operatingsystem => 'RedHat',
          :operatingsystemrelease => '7.1',
          :operatingsystemmajrelease => '7',
          :rubyversion => '1.8.7',
          :os => {
            'family' => 'RedHat',
            'release' => {
              'major' => '7',
            },
          },
        }
      end
    end
  end

  describe 'on Debian 8' do
    let(:facts) do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :operatingsystemrelease => '8.1',
        :operatingsystemmajrelease => '8',
        :rubyversion => '1.9.3',
        :os => {
          'family' => 'Debian',
          'release' => {
            'major' => '8',
          },
        },
      }
    end

    context 'with defaults for all parameters' do
      it { is_expected.to contain_package('libpam-runtime').with_ensure('present') }
      it { is_expected.not_to contain_service('oddjobd') }
      it { is_expected.not_to contain_service('messagebus') }
    end
  end
end
