require 'json'

RSpec.describe Ed448::Shake do
  describe 'shake256' do
    subject { b2h(Ed448::Shake.hash(message)) }

    let(:message) { h2b("") }

    it { expect(subject).to eq "46b9dd2b0ba88d13233b3feb743eeb243fcd52ea62b81b82b50c27646ed5762fd75dc4ddd8c0f200cb05019d67b592f6fc821c49479ab48640292eacb3b7c4be" }
  end
end
