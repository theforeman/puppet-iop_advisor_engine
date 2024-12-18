require 'spec_helper'

describe 'advisor' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let :facts do
        os_facts
      end

      describe 'with default parameters' do
        it { should compile.with_all_deps }

        it do
          is_expected.to contain_file('/etc/advisor').
            with_ensure('directory')
        end
        it do
          is_expected.to contain_file('/etc/containers/systemd/insights-satellite-engine.container.d').
            with_ensure('directory')
        end
        it do
          is_expected.to contain_file('/etc/containers/systemd/insights-satellite-engine.container.d/10-certs.conf').
            with_content(<<~MSG
              [Container]
              Secret=insights-satellite-engine-server-cert,target=/opt/app-root/src/cert.pem,mode=0440,type=mount
              Secret=insights-satellite-engine-server-key,target=/opt/app-root/src/key.pem,mode=0440,type=mount
              MSG
            )
        end
      end
    end
  end
end
