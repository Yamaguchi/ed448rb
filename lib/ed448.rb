require 'ed448/version'
require 'ffi'
require 'securerandom'

module Ed448
  extend ::FFI::Library

  module_function

  # macOS
  # ENV['LIBGOLDILOCKS'] = '/usr/local/lib/libgoldilocks.dylib'
  def init
    raise 'libgoldilocks library dose not found.' unless File.exist?(ENV['LIBGOLDILOCKS'])

    ffi_lib(ENV['LIBGOLDILOCKS'])
    load_functions
  end

  def load_functions
    # @brief EdDSA key generation.  This function uses a different (non-Decaf)
    # encoding.
    #     # @param [out] pubkey The public key.
    # @param [in] privkey The private key.
    # 
    # void goldilocks_ed448_derive_public_key (
    #     uint8_t pubkey[GOLDILOCKS_EDDSA_448_PUBLIC_BYTES],
    #     const uint8_t privkey[GOLDILOCKS_EDDSA_448_PRIVATE_BYTES]
    # )
    attach_function(:goldilocks_ed448_derive_public_key, [:pointer, :pointer], :void)

    # @brief EdDSA signing.
    #
    # @param [out] signature The signature.
    # @param [in] privkey The private key.
    # @param [in] pubkey The public key.
    # @param [in] message The message to sign.
    # @param [in] message_len The length of the message.
    # @param [in] prehashed Nonzero if the message is actually the hash of something you want to sign.
    # @param [in] context A "context" for this signature of up to 255 bytes.
    # @param [in] context_len Length of the context.
    #
    # @warning For Ed25519, it is unsafe to use the same key for both prehashed and non-prehashed
    # messages, at least without some very careful protocol-level disambiguation.  For Ed448 it is
    # safe.  The C++ wrapper is designed to make it harder to screw this up, but this C code gives
    # you no seat belt.
    # void goldilocks_ed448_sign (
    #   uint8_t signature[GOLDILOCKS_EDDSA_448_SIGNATURE_BYTES],
    #   const uint8_t privkey[GOLDILOCKS_EDDSA_448_PRIVATE_BYTES],
    #   const uint8_t pubkey[GOLDILOCKS_EDDSA_448_PUBLIC_BYTES],
    #   const uint8_t *message,
    #   size_t message_len,
    #   uint8_t prehashed,
    #   const uint8_t *context,
    #   uint8_t context_len
    # )
    attach_function(:goldilocks_ed448_sign, [:pointer, :pointer, :pointer, :pointer,:int, :int, :pointer, :int], :void)
  end

  PRIVATE_KEY_SIZE = 57
  PUBLIC_KEY_SIZE = 57
  SIGNATURE_SIZE = PRIVATE_KEY_SIZE + PUBLIC_KEY_SIZE

  def derive_public_key(private_key)
    private_key = FFI::MemoryPointer.new(:uchar, PRIVATE_KEY_SIZE).put_bytes(0, private_key)
    public_key = FFI::MemoryPointer.new(:uchar, PUBLIC_KEY_SIZE)
    goldilocks_ed448_derive_public_key(public_key, private_key)
    public_key.read_string(57)
  end

  def sign(private_key, public_key, message)
    signature = FFI::MemoryPointer.new(:uchar, SIGNATURE_SIZE)
    private_key = FFI::MemoryPointer.new(:uchar, PRIVATE_KEY_SIZE).put_bytes(0, private_key)
    public_key = FFI::MemoryPointer.new(:uchar, PUBLIC_KEY_SIZE).put_bytes(0, public_key)
    message_len = message.bytesize
    message = FFI::MemoryPointer.new(:uchar, message_len).put_bytes(0, message)
    context = FFI::MemoryPointer.new(:uchar, 0)
    goldilocks_ed448_sign(signature, private_key, public_key, message, message_len, 0, context, 0)
    signature.read_string(SIGNATURE_SIZE)
  end
end
