# frozen_string_literal: true

RSpec.describe RDStationClient::Base do
  describe '.config' do
    it { expect(described_class.config).to eq(RDStationClient::Configuration.config) }
  end

  describe 'headers' do
    subject(:client) do
      Class.new(described_class) do
        base_uri 'localhost:3000'

        private

        def make_request
          self.class.get(formatted_path, headers: headers)
        end

        def path_template
          '/test'
        end
      end
    end

    before { stub_get(to: 'localhost:3000/test') }

    it { expect(client.()).to have_succeed_with(:ok, :successful) }
  end
end
