require 'spec_helper'

describe 'profile::puppet::master' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts.merge(
            aws_assets_bucket: 'my_bucket'
          )
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('profile::puppet::master') }
        it { is_expected.to contain_class('hiera') }

        it { is_expected.to contain_class('r10k') }
        it do
          is_expected
            .to contain_exec('R10K deploy environment')
            .with_command('/opt/puppetlabs/puppet/bin/r10k deploy environment --puppetfile --verbose') # rubocop:disable Metrics/LineLength
        end
      end
    end
  end
end
