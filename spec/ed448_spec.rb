require 'json'

RSpec.describe Ed448 do
  it 'has a version number' do
    expect(Ed448::VERSION).not_to be nil
  end

  describe 'init', :without_library do
    it { expect { Ed448.init }.to raise_error(LoadError) }
  end

  describe 'test vectors' do
    path = "#{File.dirname(__FILE__)}/test_vectors.json"
    vectors = JSON.parse(File.read(path), symbolize_names: true)[:vectors]

    vectors.each.with_index do |vector, i|
      
      describe "#{i}:#{vector[:name]}" do
        let(:derived_public_key) { Ed448.derive_public_key(h2b(vector[:private_key])) }

        it { expect(b2h(derived_public_key)).to eq vector[:public_key] }

        let(:context) { h2b(vector[:context] || '') }
        let(:message) { vector[:prehash] ? Ed448::Shake.hash(h2b(vector[:message])) : h2b(vector[:message]) }
        let(:signature) { Ed448.sign(h2b(vector[:private_key]), h2b(vector[:public_key]), message, context: context, prehash: vector[:prehash]) }
        it { expect(b2h(signature)).to eq vector[:signature] }

        let(:result) { Ed448.verify(h2b(vector[:signature]), h2b(vector[:public_key]), message, context: context, prehash: vector[:prehash]) }
        it { expect(result).to be_truthy }
      end
    end
  end
end
