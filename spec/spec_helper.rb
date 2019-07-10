require "bundler/setup"
require "ed448"
require "helper"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.before(:each) do |example|
    if example.metadata[:without_library]
      ENV['LIBGOLDILOCKS'] = nil
    else
      load_lib
      Ed448.init
    end
  end
end

def load_lib
  host_os = RbConfig::CONFIG['host_os']
  case host_os
  when /darwin|mac os/
    ENV['LIBGOLDILOCKS'] = '/usr/local/lib/libgoldilocks.dylib'
  when /linux/
    ENV['LIBGOLDILOCKS'] = '/usr/local/lib/libgoldilocks.so'
  end
end
