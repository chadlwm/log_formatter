# LogFormatter

Log Formatter for Ruby and other logger.

Details as following:

- `log_formatter/ruby_json_formatter'` : ruby logger json formatter

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'log_formatter'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install log_formatter

## Usage

## Ruby Logger Json Formatter

### quick start

```
require 'logger_formatter.rb'
require 'log_formatter/ruby_json_formatter'

logger.formatter = JsonFormatterLogger::Formatter::Base.new

logger.info 'test data'
```

result:

```
```

## Test with Rspec

```
bundle exec rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at `https://github.com/chadlwm/log_formatter`. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

