module Ed448
  module Shake
    module_function

    DEFAULT_SHAKE256_LENGTH = 64

    def hash(message, length = DEFAULT_SHAKE256_LENGTH)
      message_len = message.bytesize
      message = FFI::MemoryPointer.new(:uchar, message_len).put_bytes(0, message)
      out = FFI::MemoryPointer.new(:uchar, length)
      option = FFI::MemoryPointer.new(:uchar, 8).put_bytes(0, ["004188001f80ffff"].pack('H*'))
      Ed448.goldilocks_sha3_hash(out, length, message, message_len, option)
      out.read_string(length)
    end
  end
end
