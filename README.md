# NekoMuchi [![Build Status](https://travis-ci.org/studio3104/nekomuchi.png)](https://travis-ci.org/studio3104/nekomuchi)

Server informations aggregator

## Installation

Add this line to your application's Gemfile:

    gem 'nekomuchi'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nekomuchi

## Example Usage

#### Initializing

```ruby
require 'nekomuchi/base'

hostname = 'studio3104.nekomuchi.com'
config = {
  ssh: {
    username: 'studio3104',
    options: {
       keys: ['/path/to/id_rsa'],
     },
   },
   mysql: {
     username: 'root',
     password: nil,
     port: '3306'
   },
}

nekomuchi = NekoMuchi::Base.new(hostname, config)
```

#### get some informations with single connection

```ruby
nekomuchi.const(:RedHat).get(:arch)
nekomuchi.const(:RedHat).get(:os_version)
nekomuchi.gets! #=> { RedHat: { arch: 'x86_64', os_version: 'CentOS release 6.4 (Final)' } }
```

#### Get an information, and then close connection[s]

```ruby
nekomuchi.const(:MySQL).get!(:variables, like: 'version') 
#=> { MySQL: { variables: { 'version' => '5.6.12' } } }
```

## ToDo

- changing how to treat configurations
- hold connection object on `NekoMuchi::Base` (hold per plugin instances now)
- write more plugins and plugin methods
- write more tests

## Contributing

1. Fork it ( http://github.com/studio3104/nekomuchi/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
