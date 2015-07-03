require 'spec_helper'
describe 'sssd' do

  context 'with defaults for all parameters' do
    it { should contain_class('sssd') }
  end
end
