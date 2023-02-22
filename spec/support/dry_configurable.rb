# frozen_string_literal: true

# Mor info at: https://dry-rb.org/gems/dry-configurable/0.11/testing/

require 'dry/configurable/test_interface'

RDStationClient.configuration.enable_test_interface
# module RDStationClient
#   enable_test_interface
# end

RSpec.configure do |config|
  config.before { RDStationClient.configuration.reset_config }
end
