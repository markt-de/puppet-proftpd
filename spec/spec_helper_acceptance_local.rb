# frozen_string_literal: true

require 'puppet_litmus'
require 'singleton'

class LitmusHelper
  include Singleton
  include PuppetLitmus
end

RSpec.configure do |c|
  c.before :suite do
    puts 'Running acceptance test with Puppet module puppet-epel installed'
    # Install soft dependencies.
    LitmusHelper.instance.run_shell('puppet module install puppet/epel')
  end
end
