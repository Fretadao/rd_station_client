# frozen_string_literal: true

RSpec.describe RDStationClient::Event::Create do
  describe '#run' do
    let(:event_body) { load_fixture_json('requests/event/basic.json') }
    let(:storage) { RDStationClient::AccessToken::Storage.instance }
    let(:auth_data) do
      '{"access_token":"auth-token-abc-123","expires_in":86400,"refresh_token":"refresh-token-abc-123"}'
    end

    before do
      allow(storage).to receive(:find).and_return(auth_data)
      RDStationClient::Configuration.configure do |config|
        config.base_uri = 'https://api.rd.services/'
      end

      stub_post(
        {
          headers: { 'Authorization' => 'Bearer auth-token-abc-123', 'Content-Type' => 'application/json' },
          body: event_body
        },
        to: 'https://api.rd.services/platform/events',
        response_status: response_status,
        response_body: response_body
      )
    end

    context 'and event has invalid params' do
      let(:response_status) { 422 }
      let(:response_body) do
        { errors: { error_type: 'INVALID_PARAMS', error_message: 'invalid data' } }
      end

      it 'fails with unprocessable entity', :aggregate_failures do
        result = described_class.(
          path_params: { identifier_type: :email, identifier_value: 'contact@email.com' },
          body: event_body
        )

        expect(result).to have_failed_with(:unprocessable_entity, :client_error)
        expect(result.error.parsed_response).to eq(response_body)
      end
    end

    context 'and all parameters are valid' do
      let(:response_status) { 201 }
      let(:response_body) { { event_uuid: 'abc-123' } }

      it 'creates that event', :aggregate_failures do
        result = described_class.(
          path_params: { identifier_type: :email, identifier_value: 'contact@email.com' },
          body: event_body
        )

        expect(result).to have_succeed_with(:created, :successful)
        expect(result.value[:event_uuid]).to eq('abc-123')
      end
    end
  end
end
