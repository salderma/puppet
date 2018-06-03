require 'spec_helper'

describe 'profile::monitor' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts.merge({ service_provider: 'systemd' })
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('profile::monitor') }
        it { is_expected.to contain_class('prometheus::node_exporter') }

        it { is_expected.to contain_file('/var/lib/prometheus_node_exporter')}
      end
    end
  end
end
