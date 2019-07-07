require "ed448/version"
require "ffi"
require "securerandom"

module Ed448
  include ::FFI::Library
  extend self

  module_function

  # macOS
  # ENV['LIBGOLDILOCKS'] = '/usr/local/lib/libgoldilocks.dylib'
  def init
    raise 'libgoldilocks library dose not found.' unless File.exist?(ENV['LIBGOLDILOCKS'])
    ffi_lib(ENV['LIBGOLDILOCKS'])
    load_functions
  end

  def load_functions
    attach_function(:goldilocks_ed448_derive_public_key, [:pointer, :pointer], :void)
  end

  def derive_public_key(private_key)
    private_key = FFI::MemoryPointer.new(:uchar, 57).put_bytes(0, private_key)
    public_key = FFI::MemoryPointer.new(:uchar, 57)
    goldilocks_ed448_derive_public_key(public_key, private_key)
    public_key.read_string(57)
  end
end
