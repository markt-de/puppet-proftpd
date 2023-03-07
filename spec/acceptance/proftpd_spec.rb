require 'spec_helper_acceptance'

describe 'proftpd class' do
  context 'default parameters' do
    it 'is expected to work idempotently with no errors' do
      pp = <<-EOS
      if $facts['os']['family'] == 'RedHat' {
        include epel
      }
      class { 'proftpd': }
      EOS
      # Run it twice and test for idempotency
      idempotent_apply(pp)
    end
  end
end
