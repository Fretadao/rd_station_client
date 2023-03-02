# frozen_string_literal: true

RSpec.describe RDStationClient::AccessToken::Refresh do
  describe '#run' do
    before do
      RDStationClient::Configuration.configure do |config|
        config.base_uri = 'https://api.rd.services/'
        config.rd_client_id = 'client-id'
        config.rd_secret = 'secret-key'
      end

      stub_post(
        {
          body: {
            client_id: 'client-id',
            client_secret: 'secret-key',
            refresh_token: 'actual-refresh-token'
          }
        },
        to: 'https://api.rd.services/auth/token',
        response_status: response_status,
        response_body: response_body
      )
    end

    context 'when authentication has invalid credentials' do
      let(:response_status) { 401 }
      let(:response_body) { {} }

      it 'receives an unauthorized request' do
        expect(described_class.(refresh_token: 'actual-refresh-token'))
          .to have_failed_with(:unauthorized, :client_error)
      end
    end

    context 'when authention has valid credentials' do
      let(:response_status) { 200 }
      let(:response_body) do
        {
          access_token: 'auth-token-abc-123',
          expires_in: 86_400,
          refresh_token: 'refresh-token-abc-123'
        }
      end

      it 'returns the access token', :aggregate_failures do
        authentication = described_class.(refresh_token: 'actual-refresh-token')
        expect(authentication).to have_succeed_with(:ok, :successful)

        response = authentication.value
        expect(response[:access_token]).to eq('auth-token-abc-123')
        expect(response[:refresh_token]).to eq('refresh-token-abc-123')
        expect(response[:expires_in]).to eq(86_400)
      end
    end
  end
end
