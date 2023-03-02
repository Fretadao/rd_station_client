# frozen_string_literal: true

RSpec.describe RDStationClient::Contact::Find do
  describe '#run' do
    let(:storage) { RDStationClient::AccessToken::Storage.instance }
    let(:auth_data) do
      '{"access_token":"auth-token-abc-123","expires_in":86400,"refresh_token":"refresh-token-abc-123"}'
    end

    before do
      allow(storage).to receive(:find).and_return(auth_data)
      RDStationClient::Configuration.configure do |config|
        config.base_uri = 'https://api.rd.services/'
      end
    end

    describe 'finding by path_params' do
      context 'when path params is email' do
        context 'and contact is not found' do
          let(:error_message) do
            { error_type: 'RESOURCE_NOT_FOUND', error_message: 'The resource could not be found' }
          end

          before do
            stub_get(
              { headers: { 'Authorization' => 'Bearer auth-token-abc-123', 'Content-Type' => 'application/json' } },
              to: 'https://api.rd.services/platform/contacts/email:contact@email.com',
              response_status: 404,
              response_body: { errors: error_message }
            )
          end

          it 'fails with not found', :aggregate_failures do
            result = described_class.(path_params: { identifier_type: :email, identifier_value: 'contact@email.com' })

            expect(result).to have_failed_with(:not_found, :client_error)
            expect(result.error[:errors]).to eq(error_message)
          end
        end

        context 'and contact is found' do
          let(:response_body) do
            {
              uuid: 'uuid-123',
              email: 'contact@email.com',
              name: 'Joe Milano',
              job_title: 'Founder',
              tags: ['tag_1'],
              extra_emails: [],
              legal_bases: [{ category: 'communications', type: 'consent', status: 'granted' }],
              links: [
                {
                  rel: 'SELF',
                  href: 'https//api.rd.services/platform/contacts/uuid:uuid-123',
                  media: 'application/json',
                  type: 'GET'
                },
                {
                  rel: 'SELF',
                  href: 'https//api.rd.services/platform/contacts/email:contact@email.com',
                  media: 'application/json',
                  type: 'GET'
                },
                {
                  rel: 'CONTACT.DELETE',
                  href: 'https//api.rd.services/platform/contacts/uuid:uuid-123',
                  media: 'application/json',
                  type: 'DELETE'
                }
              ]
            }
          end

          before do
            stub_get(
              { headers: { 'Authorization' => 'Bearer auth-token-abc-123', 'Content-Type' => 'application/json' } },
              to: 'https://api.rd.services/platform/contacts/email:contact@email.com',
              response_status: 200,
              response_body: response_body
            )
          end

          it 'retrives contact info', :aggregate_failures do
            result = described_class.(path_params: { identifier_type: :email, identifier_value: 'contact@email.com' })

            expect(result).to have_succeed_with(:ok, :successful)
            expect(result.value[:uuid]).to eq(response_body[:uuid])
            expect(result.value[:email]).to eq(response_body[:email])
            expect(result.value[:name]).to eq(response_body[:name])
          end
        end
      end

      context 'when path params is uuid' do
        context 'and contact is not found' do
          let(:error_message) do
            { error_type: 'RESOURCE_NOT_FOUND', error_message: 'The resource could not be found' }
          end

          before do
            stub_get(
              { headers: { 'Authorization' => 'Bearer auth-token-abc-123', 'Content-Type' => 'application/json' } },
              to: 'https://api.rd.services/platform/contacts/uuid:uuid-123',
              response_status: 404,
              response_body: { errors: error_message }
            )
          end

          it 'fails with not found', :aggregate_failures do
            result = described_class.(path_params: { identifier_type: :uuid, identifier_value: 'uuid-123' })

            expect(result).to have_failed_with(:not_found, :client_error)
            expect(result.error[:errors]).to eq(error_message)
          end
        end

        context 'and contact is found' do
          let(:response_body) do
            {
              uuid: 'uuid-123',
              email: 'contact@email.com',
              name: 'Joe Milano',
              job_title: 'Founder',
              tags: ['tag_1'],
              extra_emails: [],
              legal_bases: [{ category: 'communications', type: 'consent', status: 'granted' }],
              links: [
                {
                  rel: 'SELF',
                  href: 'https//api.rd.services/platform/contacts/uuid:uuid-123',
                  media: 'application/json',
                  type: 'GET'
                },
                {
                  rel: 'SELF',
                  href: 'https//api.rd.services/platform/contacts/email:contact@email.com',
                  media: 'application/json',
                  type: 'GET'
                },
                {
                  rel: 'CONTACT.DELETE',
                  href: 'https//api.rd.services/platform/contacts/uuid:uuid-123',
                  media: 'application/json',
                  type: 'DELETE'
                }
              ]
            }
          end

          before do
            stub_get(
              { headers: { 'Authorization' => 'Bearer auth-token-abc-123', 'Content-Type' => 'application/json' } },
              to: 'https://api.rd.services/platform/contacts/uuid:uuid-123',
              response_status: 200,
              response_body: response_body
            )
          end

          it 'retrives contact info', :aggregate_failures do
            result = described_class.(path_params: { identifier_type: :uuid, identifier_value: 'uuid-123' })

            expect(result).to have_succeed_with(:ok, :successful)
            expect(result.value[:uuid]).to eq(response_body[:uuid])
            expect(result.value[:email]).to eq(response_body[:email])
            expect(result.value[:name]).to eq(response_body[:name])
          end
        end
      end
    end

    describe 'finding by direct attribute' do
      context 'when attribute is email' do
        context 'and contact is not found' do
          let(:error_message) do
            { error_type: 'RESOURCE_NOT_FOUND', error_message: 'The resource could not be found' }
          end

          before do
            stub_get(
              { headers: { 'Authorization' => 'Bearer auth-token-abc-123', 'Content-Type' => 'application/json' } },
              to: 'https://api.rd.services/platform/contacts/email:contact@email.com',
              response_status: 404,
              response_body: { errors: error_message }
            )
          end

          it 'fails with not found', :aggregate_failures do
            result = described_class.(email: 'contact@email.com')

            expect(result).to have_failed_with(:not_found, :client_error)
            expect(result.error[:errors]).to eq(error_message)
          end
        end

        context 'and contact is found' do
          let(:response_body) do
            {
              uuid: 'uuid-123',
              email: 'contact@email.com',
              name: 'Joe Milano',
              job_title: 'Founder',
              tags: ['tag_1'],
              extra_emails: [],
              legal_bases: [{ category: 'communications', type: 'consent', status: 'granted' }],
              links: [
                {
                  rel: 'SELF',
                  href: 'https//api.rd.services/platform/contacts/uuid:uuid-123',
                  media: 'application/json',
                  type: 'GET'
                },
                {
                  rel: 'SELF',
                  href: 'https//api.rd.services/platform/contacts/email:contact@email.com',
                  media: 'application/json',
                  type: 'GET'
                },
                {
                  rel: 'CONTACT.DELETE',
                  href: 'https//api.rd.services/platform/contacts/uuid:uuid-123',
                  media: 'application/json',
                  type: 'DELETE'
                }
              ]
            }
          end

          before do
            stub_get(
              { headers: { 'Authorization' => 'Bearer auth-token-abc-123', 'Content-Type' => 'application/json' } },
              to: 'https://api.rd.services/platform/contacts/email:contact@email.com',
              response_status: 200,
              response_body: response_body
            )
          end

          it 'retrives contact info', :aggregate_failures do
            result = described_class.(email: 'contact@email.com')

            expect(result).to have_succeed_with(:ok, :successful)
            expect(result.value[:uuid]).to eq(response_body[:uuid])
            expect(result.value[:email]).to eq(response_body[:email])
            expect(result.value[:name]).to eq(response_body[:name])
          end
        end
      end

      context 'when attribute is uuid' do
        context 'and contact is not found' do
          let(:error_message) do
            { error_type: 'RESOURCE_NOT_FOUND', error_message: 'The resource could not be found' }
          end

          before do
            stub_get(
              { headers: { 'Authorization' => 'Bearer auth-token-abc-123', 'Content-Type' => 'application/json' } },
              to: 'https://api.rd.services/platform/contacts/uuid:uuid-123',
              response_status: 404,
              response_body: { errors: error_message }
            )
          end

          it 'fails with not found', :aggregate_failures do
            result = described_class.(uuid: 'uuid-123')

            expect(result).to have_failed_with(:not_found, :client_error)
            expect(result.error[:errors]).to eq(error_message)
          end
        end

        context 'and contact is found' do
          let(:response_body) do
            {
              uuid: 'uuid-123',
              email: 'contact@email.com',
              name: 'Joe Milano',
              job_title: 'Founder',
              tags: ['tag_1'],
              extra_emails: [],
              legal_bases: [{ category: 'communications', type: 'consent', status: 'granted' }],
              links: [
                {
                  rel: 'SELF',
                  href: 'https//api.rd.services/platform/contacts/uuid:uuid-123',
                  media: 'application/json',
                  type: 'GET'
                },
                {
                  rel: 'SELF',
                  href: 'https//api.rd.services/platform/contacts/email:contact@email.com',
                  media: 'application/json',
                  type: 'GET'
                },
                {
                  rel: 'CONTACT.DELETE',
                  href: 'https//api.rd.services/platform/contacts/uuid:uuid-123',
                  media: 'application/json',
                  type: 'DELETE'
                }
              ]
            }
          end

          before do
            stub_get(
              { headers: { 'Authorization' => 'Bearer auth-token-abc-123', 'Content-Type' => 'application/json' } },
              to: 'https://api.rd.services/platform/contacts/uuid:uuid-123',
              response_status: 200,
              response_body: response_body
            )
          end

          it 'retrives contact info', :aggregate_failures do
            result = described_class.(uuid: 'uuid-123')

            expect(result).to have_succeed_with(:ok, :successful)
            expect(result.value[:uuid]).to eq(response_body[:uuid])
            expect(result.value[:email]).to eq(response_body[:email])
            expect(result.value[:name]).to eq(response_body[:name])
          end
        end
      end
    end
  end
end
