shared_examples 'the default iop-advisor-engine application' do
  engine_port = 24443

  describe port(engine_port) do
    it { is_expected.to be_listening }
  end

  describe curl_command("https://localhost:#{engine_port}/api/module-update-router/v1/channel", cacert: "/etc/pki/katello/certs/katello-default-ca.crt") do
    its(:response_code) { is_expected.to eq(200) }
    its(:exit_status) { is_expected.to eq 0 }
  end
end
