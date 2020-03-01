
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ed448/version"

Gem::Specification.new do |spec|
  spec.name          = "ed448"
  spec.version       = Ed448::VERSION
  spec.authors       = ["Hajime Yamaguchi"]
  spec.email         = ["gen.yamaguchi0@gmail.com"]

  spec.summary       = 'Ruby wrapper for libgoldilocks'
  spec.description   = 'Ruby wrapper for libgoldilocks'
  spec.homepage      = "https://github.com/Yamaguchi/ed448rb"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'ffi'

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.0"
end
