require 'spec_helper_acceptance'

describe 'basic installation' do
  context 'with basic parameters' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        include iop_advisor_engine
        PUPPET
      end
    end

    include_examples 'the default iop-advisor-engine application'

    describe command('podman exec systemd-iop-advisor-engine env') do
      its(:stdout) { should match /^FOREMAN_URL=https/ }
    end
  end

  context 'with ensure false' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'iop_advisor_engine':
          ensure => 'absent'
        }
        PUPPET
      end
    end

    describe file('/etc/containers/systemd/iop-advisor-engine.container.d') do
      it { should_not exist }
    end

    describe file('/etc/containers/systemd/iop-advisor-engine.container.d/10-certs.conf') do
      it { should_not exist }
    end

    describe file('/etc/containers/systemd/iop-advisor-engine.container.d/10-certs.conf') do
      it { should_not exist }
    end

    describe service('iop-advisor-engine') do
      it { is_expected.not_to be_enabled }
      it { is_expected.not_to be_running }
    end

    describe command('podman secret inspect iop-advisor-engine-server-cert') do
      its(:exit_status) { should eq 125 }
      its(:stderr) { should match /no such secret/ }
    end
  end
end
