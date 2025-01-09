shared_examples 'the default iop-advisor-engine application' do
  engine_port = 8000

  describe port(engine_port) do
    it { is_expected.to be_listening }
  end

  # FIXME: this needs to call the right "ping" endpoint once we have one
  describe curl_command("https://localhost:#{engine_port}/", cacert: "/etc/pki/katello/certs/katello-default-ca.crt") do
    its(:response_code) { is_expected.to eq(200) }
    its(:exit_status) { is_expected.to eq 0 }
  end
end
