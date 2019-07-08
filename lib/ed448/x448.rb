module Ed448
  module X448
    module_function

    X448_PRIVATE_BYTES = 56
    X448_PUBLIC_BYTES = 56

    def dh(public_key, private_key)
      private_key = FFI::MemoryPointer.new(:uchar, X448_PRIVATE_BYTES).put_bytes(0, private_key)
      public_key = FFI::MemoryPointer.new(:uchar, X448_PUBLIC_BYTES).put_bytes(0, public_key)
      shared_key = FFI::MemoryPointer.new(:uchar, X448_PUBLIC_BYTES)
      result = Ed448.goldilocks_x448(shared_key, public_key, private_key)
      raise 'goldilocks_x448 failed.' if result != -1
      shared_key.read_bytes(X448_PUBLIC_BYTES)
    end
  end
end
