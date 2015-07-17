require 'spec_helper'
describe 'sssd' do
  describe "on RedHat 5.11" do
    let(:facts) { { :osfamily => 'RedHat', :operatingsystemrelease => '5.11' } }

    context 'with defaults for all parameters' do
      it { is_expected.to contain_class('sssd::install') }
      it { is_expected.to contain_class('sssd::config') }
      it { is_expected.to contain_class('sssd::service') }

      it { is_expected.not_to contain_package('oddjob-mkhomedir') }
      it { is_expected.not_to contain_service('oddjobd') }
    end
  end
  describe "on RedHat 6.6" do
    let(:facts) { { :osfamily => 'RedHat', :operatingsystemrelease => '6.6' } }

    context 'with defaults for all parameters' do
      it { is_expected.to contain_class('sssd::install') }
      it { is_expected.to contain_class('sssd::config') }
      it { is_expected.to contain_class('sssd::service') }

      it { is_expected.to contain_package('oddjob-mkhomedir') }
      it { is_expected.to contain_service('oddjobd') }
    end
  end
  describe "on RedHat 7.1" do
    let(:facts) { { :osfamily => 'RedHat', :operatingsystemrelease => '7.1' } }

    context 'with defaults for all parameters' do
      it { is_expected.to contain_class('sssd::install') }
      it { is_expected.to contain_class('sssd::config') }
      it { is_expected.to contain_class('sssd::service') }

      it { is_expected.to contain_package('oddjob-mkhomedir') }
      it { is_expected.to contain_service('oddjobd') }
    end
  end
  describe "on Debian 8.1" do
    let(:facts) { { :osfamily => 'Debian', :operatingsystemrelease => '8.1' } }

    context 'with defaults for all parameters' do
      it { is_expected.to contain_class('sssd::install') }
      it { is_expected.to contain_class('sssd::config') }
      it { is_expected.to contain_class('sssd::service') }

      it { is_expected.not_to contain_package('oddjob-mkhomedir') }
      it { is_expected.not_to contain_service('oddjobd') }
    end
  end
end
