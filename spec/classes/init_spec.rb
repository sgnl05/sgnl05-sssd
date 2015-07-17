require 'spec_helper'
describe 'sssd' do
  let(:facts) { { :osfamily => 'RedHat', :operatingsystemrelease => '7.1' } }

  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('sssd::install') }
    it { is_expected.to contain_class('sssd::config') }
    it { is_expected.to contain_class('sssd::service') }
  end
end
