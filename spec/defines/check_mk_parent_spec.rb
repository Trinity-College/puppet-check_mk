require 'spec_helper'
describe 'check_mk::parent', :type => :define do

  context 'prodsw1 for prod host_tags' do
    let :title do
      'prodsw1'
    end
    let :params do
      {
        :host_tags => ['prod'],
        :target    => 'target',
      }
    end
    it { should contain_concat__fragment('check_mk-prodsw1').with({
          :target  => 'target',
          :content => "  ( 'prodsw1', ['prod'], ALL_HOSTS ),\n",
          :order   => 31,
      })
    }
  end
end

