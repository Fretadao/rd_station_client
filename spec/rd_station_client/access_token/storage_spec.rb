# frozen_string_literal: true

RSpec.describe RDStationClient::AccessToken::Storage do
  describe '#instance' do
    it 'returns a singleton instance of storage' do
      expect(described_class.instance).to be_an_instance_of(described_class)
    end
  end

  describe '#find' do
    subject(:storage) { described_class.instance }

    let(:dummy_key) { 'rd_station_client:custom_key' }
    let(:redis) { Redis.new(host: 'localhost', port: '6379') }

    before do
      RDStationClient::Configuration.configure do |config|
        config.redis.pool_size = 10
        config.redis.connection_params = { host: 'localhost', port: '6379' }
      end
    end

    around do |example|
      redis.del(dummy_key)
      example.run
      redis.del(dummy_key)
    end

    context 'when the key is not stored' do
      it { expect(storage.find(:custom_key)).to be_nil }
    end

    context 'when the key is stored' do
      it 'returns stored value' do
        redis.set(dummy_key, '{"a": 1}')
        expect(storage.find(:custom_key)).to eq('{"a": 1}')
      end
    end
  end

  describe '#persist' do
    subject(:storage) { described_class.instance }

    let(:dummy_key) { 'rd_station_client:custom_key' }
    let(:redis) { Redis.new(host: 'localhost', port: '6379') }

    before do
      RDStationClient::Configuration.configure do |config|
        config.redis.pool_size = 10
        config.redis.connection_params = { host: 'localhost', port: '6379' }
      end
    end

    around do |example|
      redis.del(dummy_key)
      example.run
      redis.del(dummy_key)
    end

    context 'when the key is not stored yet' do
      it 'stores the value' do
        expect { storage.persist(:custom_key, 'Hello!') }
          .to(
            change { redis.get(dummy_key) }
              .from(nil)
              .to('Hello!')
          )
      end
    end

    context 'when the key is already stored' do
      it 'changes the stored value' do
        redis.set(dummy_key, 'Hello!')
        expect { storage.persist(:custom_key, 'Bye!') }
          .to(
            change { redis.get(dummy_key) }
              .from('Hello!')
              .to('Bye!')
          )
      end
    end
  end
end
