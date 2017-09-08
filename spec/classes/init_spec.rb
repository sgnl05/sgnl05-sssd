require 'spec_helper'
describe 'sssd' do
  describe 'on RedHat 5.11' do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :operatingsystem => 'RedHat',
        :operatingsystemrelease => '5.7',
        :operatingsystemmajrelease => '5',
        :rubyversion => '1.9.3',
      }
    end

    context 'with defaults for all parameters' do
      it { is_expected.to contain_class('sssd::install') }
      it { is_expected.to contain_class('sssd::config') }
      it { is_expected.to contain_class('sssd::service') }

      it do
        is_expected.to contain_file('sssd.conf') \
          .with_ensure('present') \
          .with_path('/etc/sssd/sssd.conf') \
          .with_content(/^# Managed by Puppet.\n\n\[sssd\]/)
      end

      it { is_expected.to contain_package('authconfig').with_ensure('latest') }
      it { is_expected.not_to contain_package('oddjob-mkhomedir') }
      it { is_expected.not_to contain_service('oddjobd') }
      it { is_expected.to contain_exec('authconfig-mkhomedir').that_comes_before('File[sssd.conf]') }

      it { is_expected.to contain_service('sssd').with_ensure('running') }
      it { is_expected.to contain_package('sssd').with_ensure('present') }
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
        }
      end
      it do
        is_expected.to contain_file('sssd.conf') \
          .with_ensure('present') \
          .with_path('/etc/sssd/sssd.conf') \
          .with_content(%r{^# Managed by Puppet.\n\n\[domain/ad.example.com\]})
      end
    end

    context 'with package_ensure set to specific version' do
      let(:params) { { :sssd_package_ensure => '1.1.1' } }
      it { is_expected.to contain_package('sssd').with_ensure('1.1.1') }
    end
  end

  describe 'on unsupported version of RedHat (not 5, 6 or 7)' do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :operatingsystem => 'RedHat',
        :operatingsystemrelease => '4.0',
        :operatingsystemmajrelease => '4',
        :rubyversion => '1.9.3',
      }
    end

    it 'should fail' do
      expect do
        should contain_class('sssd')
      end.to raise_error(Puppet::Error, /operatingsystemrelease is <4\.0> and must be in 5, 6 or 7/)
    end
  end

  describe 'on RedHat 6.6' do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :operatingsystem => 'RedHat',
        :operatingsystemrelease => '6.6',
        :operatingsystemmajrelease => '6',
        :rubyversion => '1.9.3',
      }
    end

    context 'with defaults for all parameters' do
      it { is_expected.to contain_class('sssd::install') }
      it { is_expected.to contain_class('sssd::config') }
      it { is_expected.to contain_class('sssd::service') }

      it do
        is_expected.to contain_file('sssd.conf') \
          .with_ensure('present') \
          .with_path('/etc/sssd/sssd.conf') \
          .with_content(/^# Managed by Puppet.\n\n\[sssd\]/)
      end

      it { is_expected.to contain_package('authconfig').with_ensure('present') }
      it { is_expected.to contain_package('oddjob-mkhomedir') }
      it { is_expected.to contain_service('oddjobd') }
      it { is_expected.to contain_exec('authconfig-mkhomedir').that_comes_before('File[sssd.conf]') }

      it { is_expected.to contain_service('sssd').with_ensure('running') }
      it { is_expected.to contain_package('sssd').with_ensure('present') }
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
        }
      end
      it do
        is_expected.to contain_file('sssd.conf') \
          .with_ensure('present') \
          .with_path('/etc/sssd/sssd.conf') \
          .with_content(%r{^# Managed by Puppet.\n\n\[domain/ad.example.com\]})
      end
    end

    context 'with package_ensure set to specific version' do
      let(:params) { { :sssd_package_ensure => '1.1.1' } }
      it { is_expected.to contain_package('sssd').with_ensure('1.1.1') }
    end
  end
  describe 'on RedHat 7.1' do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :operatingsystem => 'RedHat',
        :operatingsystemrelease => '7.1',
        :operatingsystemmajrelease => '7',
        :rubyversion => '1.9.3',
      }
    end

    context 'with defaults for all parameters' do
      it { is_expected.to contain_class('sssd::install') }
      it { is_expected.to contain_class('sssd::config') }
      it { is_expected.to contain_class('sssd::service') }

      it do
        is_expected.to contain_file('sssd.conf') \
          .with_ensure('present') \
          .with_path('/etc/sssd/sssd.conf') \
          .with_content(/^# Managed by Puppet.\n\n\[sssd\]/)
      end

      it { is_expected.to contain_package('authconfig').with_ensure('present') }
      it { is_expected.to contain_package('oddjob-mkhomedir') }
      it { is_expected.to contain_service('oddjobd') }
      it { is_expected.to contain_exec('authconfig-mkhomedir').that_comes_before('File[sssd.conf]') }

      it { is_expected.to contain_service('sssd').with_ensure('running') }
      it { is_expected.to contain_package('sssd').with_ensure('present') }
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
          :rubyversion => '1.8.7'
        }
      end
      it do
        is_expected.to contain_file('sssd.conf') \
          .with_ensure('present') \
          .with_path('/etc/sssd/sssd.conf') \
          .with_content(%r{^# Managed by Puppet.\n\n\[domain/ad.example.com\]})
      end
    end

    context 'with package_ensure set to specific version' do
      let(:params) { { :sssd_package_ensure => '1.1.1' } }
      it { is_expected.to contain_package('sssd').with_ensure('1.1.1') }
    end
  end
  describe 'on Debian 8.1' do
    let(:facts) do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :operatingsystemrelease => '8.1',
        :operatingsystemmajrelease => '8',
        :rubyversion => '1.9.3',
      }
    end

    context 'with defaults for all parameters' do
      it { is_expected.to contain_class('sssd::install') }
      it { is_expected.to contain_class('sssd::config') }
      it { is_expected.to contain_class('sssd::service') }

      it do
        is_expected.to contain_file('sssd.conf') \
          .with_ensure('present') \
          .with_path('/etc/sssd/sssd.conf') \
          .with_content(/^# Managed by Puppet.\n\n\[sssd\]/)
      end

      it { is_expected.not_to contain_package('authconfig') }
      it { is_expected.not_to contain_package('oddjob-mkhomedir') }
      it { is_expected.to contain_package('libpam-runtime').with_ensure('present') }
      it { is_expected.not_to contain_service('oddjobd') }

      it { is_expected.to contain_service('sssd').with_ensure('running') }
      it { is_expected.to contain_package('sssd').with_ensure('present') }
      it { is_expected.not_to contain_service('messagebus') }
    end

    context 'with service ensure stopped' do
      let(:params) { { :service_ensure => 'stopped' } }
      it { is_expected.to contain_service('sssd').with_ensure('stopped') }
    end

    context 'with ruby without ordered hashes' do
      let(:facts) do
        {
          :osfamily => 'Debian',
          :operatingsystem => 'Debian',
          :operatingsystemrelease => '8.1',
          :operatingsystemmajrelease => '8',
          :rubyversion => '1.8.7'
        }
      end
      it do
        is_expected.to contain_file('sssd.conf') \
          .with_ensure('present') \
          .with_path('/etc/sssd/sssd.conf') \
          .with_content(%r{^# Managed by Puppet.\n\n\[domain/ad.example.com\]})
      end
    end

    context 'with package_ensure set to specific version' do
      let(:params) { { :sssd_package_ensure => '1.1.1' } }
      it { is_expected.to contain_package('sssd').with_ensure('1.1.1') }
    end
  end
  describe 'on Suse 11.4' do
    let(:facts) do
      {
        :osfamily => 'Suse',
        :operatingsystem => 'SLES',
        :operatingsystemrelease => '11.4',
        :operatingsystemmajrelease => '11',
        :rubyversion => '2.1.9',
      }
    end

    context 'with defaults for all parameters' do
      it { is_expected.to contain_class('sssd::install') }
      it { is_expected.to contain_class('sssd::config') }
      it { is_expected.to contain_class('sssd::service') }

      it do
        is_expected.to contain_file('sssd.conf') \
          .with_ensure('present') \
          .with_path('/etc/sssd/sssd.conf') \
          .with_content(/^# Managed by Puppet.\n\n\[sssd\]/)
      end

      it { is_expected.to contain_package('sssd-32bit').with_ensure('present') }
      it { is_expected.to contain_package('sssd-tools').with_ensure('present') }

      it { is_expected.to contain_service('sssd').with_ensure('running') }
      it { is_expected.to contain_package('sssd').with_ensure('present') }
    end

    context 'with service ensure stopped' do
      let(:params) { { :service_ensure => 'stopped' } }
      it { is_expected.to contain_service('sssd').with_ensure('stopped') }
    end

    context 'with ruby without ordered hashes' do
      let(:facts) do
        {
          :osfamily => 'Suse',
          :operatingsystem => 'SLES',
          :operatingsystemrelease => '11.4',
          :operatingsystemmajrelease => '11',
          :rubyversion => '1.8.7'
        }
      end
      it do
        is_expected.to contain_file('sssd.conf') \
          .with_ensure('present') \
          .with_path('/etc/sssd/sssd.conf') \
          .with_content(%r{^# Managed by Puppet.\n\n\[domain/ad.example.com\]})
      end
    end
    context 'with package_ensure set to specific version' do
      let(:params) { { :sssd_package_ensure => '1.1.1' } }
      it { is_expected.to contain_package('sssd').with_ensure('1.1.1') }
    end
  end
  describe 'on Suse 12.1' do
    let(:facts) do
      {
        :osfamily => 'Suse',
        :operatingsystem => 'SLES',
        :operatingsystemrelease => '12.1',
        :operatingsystemmajrelease => '12',
        :rubyversion => '2.1.9',
      }
    end

    context 'with defaults for all parameters' do
      it { is_expected.to contain_class('sssd::install') }
      it { is_expected.to contain_class('sssd::config') }
      it { is_expected.to contain_class('sssd::service') }

      it do
        is_expected.to contain_file('sssd.conf') \
          .with_ensure('present') \
          .with_path('/etc/sssd/sssd.conf') \
          .with_content(/^# Managed by Puppet.\n\n\[sssd\]/)
      end
      
      it { is_expected.to contain_package('sssd-krb5').with_ensure('present') }
      it { is_expected.to contain_package('sssd-ad').with_ensure('present') }
      it { is_expected.to contain_package('sssd-ipa').with_ensure('present') }
      it { is_expected.to contain_package('sssd-32bit').with_ensure('present') }
      it { is_expected.to contain_package('sssd-tools').with_ensure('present') }
      it { is_expected.to contain_package('sssd-ldap').with_ensure('present') }

      it { is_expected.to contain_service('sssd').with_ensure('running') }
      it { is_expected.to contain_package('sssd').with_ensure('present') }
    end

    context 'with service ensure stopped' do
      let(:params) { { :service_ensure => 'stopped' } }
      it { is_expected.to contain_service('sssd').with_ensure('stopped') }
    end

    context 'with ruby without ordered hashes' do
      let(:facts) do
        {
          :osfamily => 'Suse',
          :operatingsystem => 'SLES',
          :operatingsystemrelease => '12.1',
          :operatingsystemmajrelease => '12',
          :rubyversion => '1.8.7'
        }
      end
      it do
        is_expected.to contain_file('sssd.conf') \
          .with_ensure('present') \
          .with_path('/etc/sssd/sssd.conf') \
          .with_content(%r{^# Managed by Puppet.\n\n\[domain/ad.example.com\]})
      end
    end
    context 'with package_ensure set to specific version' do
      let(:params) { { :sssd_package_ensure => '1.1.1' } }
      it { is_expected.to contain_package('sssd').with_ensure('1.1.1') }
    end
  end
end
