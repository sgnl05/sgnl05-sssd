require 'spec_helper'
describe 'sssd' do
  describe 'on RedHat 5.11' do
    let(:facts) { { :osfamily => 'RedHat', :operatingsystemrelease => '5.7' } }

    context 'with defaults for all parameters' do
      it { is_expected.to contain_class('sssd::install') }
      it { is_expected.to contain_class('sssd::config') }
      it { is_expected.to contain_class('sssd::service') }

      it { is_expected.to contain_package('authconfig').with_ensure('latest') }
      it { is_expected.not_to contain_package('oddjob-mkhomedir') }
      it { is_expected.not_to contain_service('oddjobd') }
      it { should contain_exec('authconfig-mkhomedir').that_comes_before('File[sssd.conf]') }

      it { is_expected.to contain_service('sssd').with_ensure('running') }
    end

    context 'with service ensure stopped' do
      let(:params) { { :service_ensure => 'stopped' } }
      it { is_expected.to contain_service('sssd').with_ensure('stopped') }
    end
  end
  describe 'on RedHat 6.6' do
    let(:facts) { { :osfamily => 'RedHat', :operatingsystemrelease => '6.6' } }

    context 'with defaults for all parameters' do
      it { is_expected.to contain_class('sssd::install') }
      it { is_expected.to contain_class('sssd::config') }
      it { is_expected.to contain_class('sssd::service') }

      it { is_expected.to contain_package('authconfig').with_ensure('present') }
      it { is_expected.to contain_package('oddjob-mkhomedir') }
      it { is_expected.to contain_service('oddjobd') }
      it { should contain_exec('authconfig-mkhomedir').that_comes_before('File[sssd.conf]') }

      it { is_expected.to contain_service('sssd').with_ensure('running') }
      it { is_expected.to contain_service('oddjobd').with_ensure('running') }
    end

    context 'with service ensure stopped' do
      let(:params) { { :service_ensure => 'stopped' } }
      it { is_expected.to contain_service('sssd').with_ensure('stopped') }
      it { is_expected.to contain_service('oddjobd').with_ensure('stopped') }
    end
  end
  describe 'on RedHat 7.1' do
    let(:facts) { { :osfamily => 'RedHat', :operatingsystemrelease => '7.1' } }

    context 'with defaults for all parameters' do
      it { is_expected.to contain_class('sssd::install') }
      it { is_expected.to contain_class('sssd::config') }
      it { is_expected.to contain_class('sssd::service') }

      it { is_expected.to contain_package('authconfig').with_ensure('present') }
      it { is_expected.to contain_package('oddjob-mkhomedir') }
      it { is_expected.to contain_service('oddjobd') }

      it { is_expected.to contain_service('sssd').with_ensure('running') }
      it { is_expected.to contain_service('oddjobd').with_ensure('running') }
    end

    context 'with service ensure stopped' do
      let(:params) { { :service_ensure => 'stopped' } }
      it { is_expected.to contain_service('sssd').with_ensure('stopped') }
      it { is_expected.to contain_service('oddjobd').with_ensure('stopped') }
    end
  end
  describe 'on Debian 8.1' do
    let(:facts) { { :osfamily => 'Debian', :operatingsystemrelease => '8.1' } }

    context 'with defaults for all parameters' do
      it { is_expected.to contain_class('sssd::install') }
      it { is_expected.to contain_class('sssd::config') }
      it { is_expected.to contain_class('sssd::service') }

      it { is_expected.not_to contain_package('authconfig') }
      it { is_expected.not_to contain_package('oddjob-mkhomedir') }
      it { is_expected.to contain_package('libpam-runtime').with_ensure('present') }
      it { is_expected.not_to contain_service('oddjobd') }

      it { is_expected.to contain_service('sssd').with_ensure('running') }
    end

    context 'with service ensure stopped' do
      let(:params) { { :service_ensure => 'stopped' } }
      it { is_expected.to contain_service('sssd').with_ensure('stopped') }
    end
  end
end
