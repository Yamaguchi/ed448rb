require 'ed448/version'
require 'ffi'
require 'securerandom'

module Ed448
  extend ::FFI::Library

  module_function

  autoload :Shake, 'ed448/shake'
  autoload :X448, 'ed448/x448'

  EDDSA_448_PUBLIC_BYTES = 57
  EDDSA_448_PRIVATE_BYTES = 57
  EDDSA_448_SIGNATURE_BYTES = EDDSA_448_PRIVATE_BYTES + EDDSA_448_PUBLIC_BYTES

  # macOS
  # ENV['LIBGOLDILOCKS'] = '/usr/local/lib/libgoldilocks.dylib'
  def init
    raise LoadError unless ENV['LIBGOLDILOCKS']
    raise LoadError unless File.exist?(ENV['LIBGOLDILOCKS'])

    ffi_lib(ENV['LIBGOLDILOCKS'])
    load_functions
  end

  def load_functions
    # @brief EdDSA key generation.  This function uses a different (non-Decaf)
    # encoding.
    #
    # @param [out] pubkey The public key.
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
    #
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

    # @brief EdDSA signature verification.
    #
    # Uses the standard (i.e. less-strict) verification formula.
    #
    # @param [in] signature The signature.
    # @param [in] pubkey The public key.
    # @param [in] message The message to verify.
    # @param [in] message_len The length of the message.
    # @param [in] prehashed Nonzero if the message is actually the hash of something you want to verify.
    # @param [in] context A "context" for this signature of up to 255 bytes.
    # @param [in] context_len Length of the context.
    #
    # @warning For Ed25519, it is unsafe to use the same key for both prehashed and non-prehashed
    # messages, at least without some very careful protocol-level disambiguation.  For Ed448 it is
    # safe.  The C++ wrapper is designed to make it harder to screw this up, but this C code gives
    # you no seat belt.
    #
    # goldilocks_error_t goldilocks_ed448_verify (
    #     const uint8_t signature[GOLDILOCKS_EDDSA_448_SIGNATURE_BYTES],
    #     const uint8_t pubkey[GOLDILOCKS_EDDSA_448_PUBLIC_BYTES],
    #     const uint8_t *message,
    #     size_t message_len,
    #     uint8_t prehashed,
    #     const uint8_t *context,
    #     uint8_t context_len
    # )
    attach_function(:goldilocks_ed448_verify, [:pointer, :pointer, :pointer,:int, :int, :pointer, :int], :int)

    # @brief RFC 7748 Diffie-Hellman scalarmul, used to compute shared secrets.
    # This function uses a different (non-Decaf) encoding.
    #
    # @param [out] shared The shared secret base*scalar
    # @param [in] base The other party's public key, used as the base of the scalarmul.
    # @param [in] scalar The private scalar to multiply by.
    #
    # @retval GOLDILOCKS_SUCCESS The scalarmul succeeded.
    # @retval GOLDILOCKS_FAILURE The scalarmul didn't succeed, because the base
    # point is in a small subgroup.
    #
    # goldilocks_error_t goldilocks_x448 (
    #     uint8_t shared[GOLDILOCKS_X448_PUBLIC_BYTES],
    #     const uint8_t base[GOLDILOCKS_X448_PUBLIC_BYTES],
    #     const uint8_t scalar[GOLDILOCKS_X448_PRIVATE_BYTES]
    # ) GOLDILOCKS_API_VIS GOLDILOCKS_NONNULL GOLDILOCKS_WARN_UNUSED GOLDILOCKS_NOINLINE;
    attach_function(:goldilocks_x448, [:pointer, :pointer, :pointer], :int)

    # @brief RFC 7748 Diffie-Hellman base point scalarmul.  This function uses
    # a different (non-Decaf) encoding.
    #
    # @param [out] out The public key base*scalar
    # @param [in] scalar The private scalar.
    #
    # void goldilocks_x448_derive_public_key (
    #     uint8_t out[GOLDILOCKS_X448_PUBLIC_BYTES],
    #     const uint8_t scalar[GOLDILOCKS_X448_PRIVATE_BYTES]
    # ) GOLDILOCKS_API_VIS GOLDILOCKS_NONNULL GOLDILOCKS_NOINLINE;
    attach_function(:goldilocks_x448_derive_public_key, [:pointer, :pointer], :void)

    #  @brief Hash (in) to (out)
    #  @param [in] in The input data.
    #  @param [in] inlen The length of the input data.
    #  @param [out] out A buffer for the output data.
    #  @param [in] outlen The length of the output data.
    #  @param [in] params The parameters of the sponge hash.
    #
    # goldilocks_error_t goldilocks_sha3_hash (
    #     uint8_t *out,
    #     size_t outlen,
    #     const uint8_t *in,
    #     size_t inlen,
    #     const struct goldilocks_kparams_s *params
    # ) GOLDILOCKS_API_VIS;
    attach_function(:goldilocks_sha3_hash, [:pointer, :int, :pointer, :int, :pointer], :int)
  end

  def derive_public_key(private_key)
    private_key = FFI::MemoryPointer.new(:uchar, EDDSA_448_PRIVATE_BYTES).put_bytes(0, private_key)
    public_key = FFI::MemoryPointer.new(:uchar, EDDSA_448_PUBLIC_BYTES)
    goldilocks_ed448_derive_public_key(public_key, private_key)
    public_key.read_string(EDDSA_448_PUBLIC_BYTES)
  end

  def sign(private_key, public_key, message, context: '', prehash: false)
    signature = FFI::MemoryPointer.new(:uchar, EDDSA_448_SIGNATURE_BYTES)
    private_key = FFI::MemoryPointer.new(:uchar, EDDSA_448_PRIVATE_BYTES).put_bytes(0, private_key)
    public_key = FFI::MemoryPointer.new(:uchar, EDDSA_448_PUBLIC_BYTES).put_bytes(0, public_key)
    message_len = message.bytesize
    message = FFI::MemoryPointer.new(:uchar, message_len).put_bytes(0, message)
    context_len = context.bytesize
    context = FFI::MemoryPointer.new(:uchar, context_len).put_bytes(0, context)
    goldilocks_ed448_sign(signature, private_key, public_key, message, message_len, prehash ? 1 : 0, context, context_len)
    signature.read_string(EDDSA_448_SIGNATURE_BYTES)
  end

  def verify(signature, public_key, message, context: '', prehash: false)
    signature = FFI::MemoryPointer.new(:uchar, EDDSA_448_SIGNATURE_BYTES).put_bytes(0, signature)
    public_key = FFI::MemoryPointer.new(:uchar, EDDSA_448_PUBLIC_BYTES).put_bytes(0, public_key)
    message_len = message.bytesize
    message = FFI::MemoryPointer.new(:uchar, message_len).put_bytes(0, message)
    context_len = context.bytesize
    context = FFI::MemoryPointer.new(:uchar, context_len).put_bytes(0, context)
    result = goldilocks_ed448_verify(signature, public_key, message, message_len, prehash ? 1 : 0, context, context_len)
    result == -1
  end
end
