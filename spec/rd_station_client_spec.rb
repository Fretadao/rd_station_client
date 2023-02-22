# frozen_string_literal: true

RSpec.describe RDStationClient do
  describe 'versioning' do
    it 'has a version number' do
      expect(RDStationClient::VERSION).not_to be_nil
    end
  end
end
