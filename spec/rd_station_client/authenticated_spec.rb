# frozen_string_literal: true

RSpec.describe RDStationClient::Authenticated do
  describe '.config' do
    it { expect(described_class.config).to eq(RDStationClient::Configuration.config) }
  end

  describe '#run' do
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

    let(:storage) { RDStationClient::AccessToken::Storage.instance }

    before { allow(storage).to receive(:find).with(:auth_data).and_return(auth_data) }

    context 'when there is no authentication data' do
      let(:auth_data) { nil }

      context 'but authentication fails' do
        before do
          mock_service(RDStationClient::AccessToken::Generate, result: :failure, types: [:unauthorized, :client_error])
        end

        it { expect(client.()).to have_failed_with(:unauthorized, :client_error) }
      end

      context 'and authentication gets success' do
        let(:authentication_data) do
          {
            access_token: 'autenticated-abc-123',
            expires_in: 86_400,
            refresh_token: 'refresh-authenticated-abc-123'
          }
        end

        before do
          mock_service(
            RDStationClient::AccessToken::Generate,
            result: :success,
            types: [:ok, :successful],
            value: authentication_data
          )

          stub_get(
            { headers: { 'Authorization' => 'Bearer autenticated-abc-123', 'Content-Type' => 'application/json' } },
            to: 'localhost:3000/test',
            response_body: { a: 1 }
          )

          allow(storage).to receive(:persist).with(:auth_data, authentication_data)
        end

        it 'performs an authenticated request' do
          expect(client.()).to have_succeed_with(:ok, :successful)
        end
      end
    end

    context 'when there is authentication data' do
      let(:auth_data) do
        '{"access_token":"auth-token-abc-123","expires_in":86400,"refresh_token":"refresh-token-abc-123"}'
      end

      context 'but token has already been expired' do
        before do
          stub_get(
            { headers: { 'Authorization' => 'Bearer auth-token-abc-123', 'Content-Type' => 'application/json' } },
            to: 'localhost:3000/test',
            response_status: 401
          )
        end

        context 'but refresh token is unauthorized' do
          before do
            mock_service(RDStationClient::AccessToken::Refresh, result: :failure, types: [:unauthorized, :client_error])
          end

          it { expect(client.()).to have_failed_with(:unauthorized, :client_error) }
        end

        context 'and refresh token is retrieved' do
          let(:refreshed_authentication_data) do
            {
              access_token: 'refreshed-autenticated-abc-123',
              expires_in: 86_400,
              refresh_token: 'refreshed-refresh-authenticated-abc-123'
            }
          end

          before do
            mock_service(
              RDStationClient::AccessToken::Refresh,
              result: :success,
              types: [:ok, :successful],
              value: refreshed_authentication_data
            )

            stub_get(
              {
                headers: {
                  'Authorization' => 'Bearer refreshed-autenticated-abc-123',
                  'Content-Type' => 'application/json'
                }
              },
              to: 'localhost:3000/test',
              response_body: { a: 1 }
            )

            allow(storage).to receive(:persist).with(:auth_data, refreshed_authentication_data)
          end

          it 'performs an authenticated request' do
            expect(client.()).to have_succeed_with(:ok, :successful)
          end
        end
      end
    end
  end
end
