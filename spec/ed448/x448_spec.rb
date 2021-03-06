RSpec.describe Ed448::X448 do
  # https://tools.ietf.org/html/rfc7748#section-6.2
  describe '.derive_public_key' do
    let(:alice_private_key) { '9a8f4925d1519f5775cf46b04b5800d4ee9ee8bae8bc5565d498c28dd9c9baf574a9419744897391006382a6f127ab1d9ac2d8c0a598726b' }
    let(:alice_public_key) { '9b08f7cc31b7e3e67d22d5aea121074a273bd2b83de09c63faa73d2c22c5d9bbc836647241d953d40c5b12da88120d53177f80e532c41fa0' }
    let(:bob_private_key) { '1c306a7ac2a0e2e0990b294470cba339e6453772b075811d8fad0d1d6927c120bb5ee8972b0d3e21374c9c921b09d1b0366f10b65173992d' }
    let(:bob_public_key) { '3eb7a829b0cd20f5bcfc0b599b6feccf6da4627107bdb0d4f345b43027d8b972fc3e34fb4232a13ca706dcb57aec3dae07bdc1c67bf33609' }

    it 'alice' do
      Ed448.init
      expect(b2h(Ed448::X448.derive_public_key(h2b(alice_private_key)))).to eq alice_public_key
    end

    it 'bob' do
      Ed448.init
      expect(b2h(Ed448::X448.derive_public_key(h2b(bob_private_key)))).to eq bob_public_key
    end
  end

  describe '.dh' do
    let(:alice_private_key) { '9a8f4925d1519f5775cf46b04b5800d4ee9ee8bae8bc5565d498c28dd9c9baf574a9419744897391006382a6f127ab1d9ac2d8c0a598726b' }
    let(:alice_public_key) { '9b08f7cc31b7e3e67d22d5aea121074a273bd2b83de09c63faa73d2c22c5d9bbc836647241d953d40c5b12da88120d53177f80e532c41fa0' }
    let(:bob_private_key) { '1c306a7ac2a0e2e0990b294470cba339e6453772b075811d8fad0d1d6927c120bb5ee8972b0d3e21374c9c921b09d1b0366f10b65173992d' }
    let(:bob_public_key) { '3eb7a829b0cd20f5bcfc0b599b6feccf6da4627107bdb0d4f345b43027d8b972fc3e34fb4232a13ca706dcb57aec3dae07bdc1c67bf33609' }
    let(:shared_key) { '07fff4181ac6cc95ec1c16a94a0f74d12da232ce40a77552281d282bb60c0b56fd2464c335543936521c24403085d59a449a5037514a879d' }

    it 'alice side' do
      Ed448.init
      expect(b2h(Ed448::X448.dh(h2b(bob_public_key), h2b(alice_private_key)))).to eq shared_key
    end

    it 'bob side' do
      Ed448.init
      expect(b2h(Ed448::X448.dh(h2b(alice_public_key), h2b(bob_private_key)))).to eq shared_key
    end
  end
end
