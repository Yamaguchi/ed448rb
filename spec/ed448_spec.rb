RSpec.describe Ed448 do
  it "has a version number" do
    expect(Ed448::VERSION).not_to be nil
  end

  describe 'generate_keypair' do
    subject { Ed448.derive_public_key([private_key].pack("H114")).unpack("H114").first }

    before { Ed448.init }

    # https://tools.ietf.org/html/rfc8032#section-7.4
    context 'Blank' do
      let(:private_key) { "6c82a562cb808d10d632be89c8513ebf6c929f34ddfa8c9f63c9960ef6e348a3528c8a3fcc2f044e39a3fc5b94492f8f032e7549a20098f95b" }
      let(:public_key) { "5fd7449b59b461fd2ce787ec616ad46a1da1342485a70e1f8a0ea75d80e96778edf124769b46c7061bd6783df1e50f6cd1fa1abeafe8256180" }

      it { is_expected.to eq public_key }
    end

    context '1 octet' do
      let(:private_key) { "c4eab05d357007c632f3dbb48489924d552b08fe0c353a0d4a1f00acda2c463afbea67c5e8d2877c5e3bc397a659949ef8021e954e0a12274e" }
      let(:public_key) { "43ba28f430cdff456ae531545f7ecd0ac834a55d9358c0372bfa0c6c6798c0866aea01eb00742802b8438ea4cb82169c235160627b4c3a9480" }

      it { is_expected.to eq public_key }
    end

    context '11 octets' do
      let(:private_key) { "cd23d24f714274e744343237b93290f511f6425f98e64459ff203e8985083ffdf60500553abc0e05cd02184bdb89c4ccd67e187951267eb328" }
      let(:public_key) { "dcea9e78f35a1bf3499a831b10b86c90aac01cd84b67a0109b55a36e9328b1e365fce161d71ce7131a543ea4cb5f7e9f1d8b00696447001400" }

      it { is_expected.to eq public_key }
    end

    context '12 octets' do
      let(:private_key) { "258cdd4ada32ed9c9ff54e63756ae582fb8fab2ac721f2c8e676a72768513d939f63dddb55609133f29adf86ec9929dccb52c1c5fd2ff7e21b" }
      let(:public_key) { "3ba16da0c6f2cc1f30187740756f5e798d6bc5fc015d7c63cc9510ee3fd44adc24d8e968b6e46e6f94d19b945361726bd75e149ef09817f580" }

      it { is_expected.to eq public_key }
    end
  end
end
