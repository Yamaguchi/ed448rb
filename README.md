# Ed448



## Installation

This gem needs libgoldilocks(https://github.com/otrv4/libgoldilocks)

First, install libgoldilocks as described in [libgoldilocks](https://github.com/otrv4/libgoldilocks).

And then, set environment variable as followings:

```
export LIBGOLDILOCKS=path/to/library
```

In most cases, the path will be 

* `/usr/local/lib/libgoldilocks.dylib` on macOS
* `/usr/local/lib/libgoldilocks.so` on Ubuntu

Add this line to your application's Gemfile:

```ruby
gem 'ed448'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ed448

## Usage

### Load library

    $ bin/console
    > Ed448.init

### Derive private/public key pair

    > private_key = SecureRandom.hex(57)
    => "32ea23b42ab68e3e21308c5cbcfb4217a6cf4f970a6b01def37d83cd5904cb96d4c188cb6a8c4e9cea758cbfbd871f2d6aa122a2ea834e9c86"
    > derived = Ed448.derive_public_key([private_key].pack("H*"))
    => "\xF4\xED\xACe\xE9\xF0 \xBC0V\xB4\x90\f\xF7\xB6\xFB\x9A2Bv)4\xF9.Y\xBA\xB9\xFE7Y\xDAC\x8Dd!G\x8D\x06+\xAB\xF3\xE8\xBCf`\x18mrB\xE7/\xBB\xCD\xA8\x1A\xFF\x00"
    > public_key = derived.unpack1("H*")
    => "f4edac65e9f020bc3056b4900cf7b6fb9a3242762934f92e59bab9fe3759da438d6421478d062babf3e8bc6660186d7242e72fbbcda81aff00"

### Sign

    > message = ["64a65f3cdedcdd66811e2915"].pack("H*")
    => "d\xA6_<\xDE\xDC\xDDf\x81\x1E)\x15"
    > signature = Ed448.sign([private_key].pack("H*"), [public_key].pack("H*"), message)
    => "\xF7:\xD3\x98Y\x00\x1D\"\x9A\nJ\x16\xE9\xF0k\xD6\xE3\x9C\xDCy\v\x13'\xC8\x9C`Ooo\x1A@\xC0\a\xB3\x7F\xC2\b\x84\x98\x1E\xADt/\xEB\xB6\x84/\xF3\xF6,\x93@\xF8b\x15F\x80i\xF3\xCC\xDEG\xB9`\x9C\x9F\xF8+8,\xB8\xB6\x89x\xD9'\x91c\x1C\xFB\x10/\xFDq)J_jS\xF8\xC1\x1C\x8BB\xB4\xADC\xD5\x16\xFF\xA5\xE7\x04'\xD1\x01\xE0\xD8\xF6jH\x91'\x00"
    irb(main):026:0> signature.unpack1("H*")
    => "f73ad39859001d229a0a4a16e9f06bd6e39cdc790b1327c89c604f6f6f1a40c007b37fc20884981ead742febb6842ff3f62c9340f86215468069f3ccde47b9609c9ff82b382cb8b68978d92791631cfb102ffd71294a5f6a53f8c11c8b42b4ad43d516ffa5e70427d101e0d8f66a48912700"

### Verify
    
    > Ed448.verify(signature, [public_key].pack("H*"), message)
    => true

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Yamaguchi/ed448rb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ed448rb project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/ed448rb/blob/master/CODE_OF_CONDUCT.md).
