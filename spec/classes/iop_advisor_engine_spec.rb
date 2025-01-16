require 'spec_helper'

describe 'iop_advisor_engine' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let :facts do
        os_facts
      end

      describe 'with default parameters' do
        it { should compile.with_all_deps }

        it do
          is_expected.to contain_file('/etc/iop-advisor-engine').
            with_ensure('directory')
        end
        it do
          is_expected.to contain_file('/etc/containers/systemd/iop-advisor-engine.container.d').
            with_ensure('directory')
        end
        it do
          is_expected.to contain_file('/etc/containers/systemd/iop-advisor-engine.container.d/10-certs.conf').
            with_content(<<~MSG
              [Container]
              Secret=iop-advisor-engine-server-cert,target=/opt/app-root/src/cert.pem,mode=0440,type=mount
              Secret=iop-advisor-engine-server-key,target=/opt/app-root/src/key.pem,mode=0440,type=mount
              Secret=iop-advisor-engine-server-ca-cert,target=/opt/app-root/src/ca.pem,mode=0440,type=mount
              Secret=iop-advisor-engine-client-cert,target=/opt/app-root/src/client_cert.pem,mode=0440,type=mount
              Secret=iop-advisor-engine-client-key,target=/opt/app-root/src/client_key.pem,mode=0440,type=mount
              Secret=iop-advisor-engine-client-ca-cert,target=/opt/app-root/src/client_ca.pem,mode=0440,type=mount
              MSG
            )
        end
      end

      describe 'with ensure absent' do
        let :params do
          {ensure: 'absent'}
        end

        it { should compile.with_all_deps }

        it do
          is_expected.to contain_file('/etc/containers/systemd/iop-advisor-engine.container.d').
            with_ensure('absent')
        end
        it do
          is_expected.to contain_file('/etc/containers/systemd/iop-advisor-engine.container.d/10-certs.conf').
            with_ensure('absent')
        end
        it do
          is_expected.to contain_podman__quadlet('iop-advisor-engine').
            with_ensure('absent')
        end
      end
    end
  end
end
