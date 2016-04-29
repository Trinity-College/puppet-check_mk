require 'spec_helper'
describe 'check_mk::check_parameters', :type => :define do

  context 'with required parameters, order, ALL_HOSTS' do
    let :facts do
      { :fqdn => 'host.example.com', }
    end
    let :title do
      'fs_default'
    end
    let :params do
      {
          :description => 'Filesystem default thresholds',
          :order       => 5,
          :parameters  => '(90, 95)',
          :hosts       => 'ALL_HOSTS',
          :services    => ['fs_'],
          :target      => 'target',
      }
    end
    it { should contain_concat__fragment('check_mk-fs_default-host.example.com').with({
          :target  => 'target',
          :content => "  ( (90, 95), ALL_HOSTS, [ 'fs_' ] \),\n",
          :order   => 36,
      })
    }
  end
  context 'with tags, hosts' do
    let :facts do
      { :fqdn => 'host.example.com', }
    end
    let :title do
      'fs_default'
    end
    let :params do
      {
          :description => 'Filesystem default thresholds',
          :tags        => ['debian', 'prod'],
          :parameters  => '(90, 95)',
          :hosts       => ['host1', 'host2'],
          :services    => ['fs_'],
          :target      => 'target',
      }
    end
    it { should contain_concat__fragment('check_mk-fs_default-host.example.com').with({
          :target  => 'target',
          :content => "  ( (90, 95), [ 'debian', 'prod' ], [ 'host1', 'host2' ], [ 'fs_' ] \),\n",
          :order   => 31,
      })
    }
  end
end

