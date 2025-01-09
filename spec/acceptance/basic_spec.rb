require 'spec_helper_acceptance'

describe 'basic installation' do
  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      include iop_advisor_engine
      PUPPET
    end
  end

  include_examples 'the default iop-advisor-engine application'
end
