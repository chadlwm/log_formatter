# LogFormatter

Log Formatter for Ruby and other logger.

Details as following:

- `log_formatter/ruby_json_formatter'` : ruby logger json formatter
- `log_formatter/log4r_json_formatter'` : log4r logger json formatter

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

logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG

logger.formatter = Ruby::JSONFormatter::Base.new

logger.info 'test data'
```

result:

```
{
  "message": "test data",
  "log_level": "INFO",
  "log_type": null,
  "log_app": null,
  "log_timestamp": "2016-08-25T15:34:25+08:00"
}
```

### set app and common ext info

```
logger.formatter =  Ruby::JSONFormatter::Base.new('app', {'source': 'examples'})
logger.info 'test data'
```

result:

```
{
  "source": "examples",
  "message": "test data",
  "log_level": "INFO",
  "log_type": null,
  "log_app": "app",
  "log_timestamp": "2016-08-25T15:34:25+08:00"
}
```

### log with hash

```
logger.formatter =  Ruby::JSONFormatter::Base.new('app', {'source': 'examples'})

logger.debug({data: "test data", author: 'chad'})
```

result:

```
{
  "source": "examples",
  "data": "test data",
  "author": "chad",
  "log_level": "DEBUG",
  "log_type": null,
  "log_app": "app",
  "log_timestamp": "2016-08-25T15:34:25+08:00"
}
```

### reset the defaut key

json formatter will add `log_type`,`log_level`,`log_timestamp`，`log_app` as default key, but you can change them if needed.

```
logger.formatter =  Ruby::JSONFormatter::Base.new('app', {'source': 'examples'}) do |config|
  config[:level] = :cus_level
  config[:type] = :cus_type
  config[:app] = :cus_app
  config[:timestamp] = :cus_timestamp
end

logger.debug({data: "test data", age: 18})
```

result:

```
{
  "source": "examples",
  "data": "test data",
  age: 18,
  "cus_level": "DEBUG",
  "cus_type": null,
  "cus_app": "app",
  "cus_timestamp": "2016-08-25T15:34:25+08:00"
}
```

full code to see [examples/ruby_logger](https://github.com/chadlwm/log_formatter/blob/master/examples/ruby_logger.rb)


## Log4r JSON Formatter

### Get Start

```
logger = Log4r::Logger.new('Log4RTest')
outputter = Log4r::StdoutOutputter.new(
  "console",
  :formatter => Log4r::JSONFormatter::Base.new
)
logger.add(outputter)

logger.debug("Created logger")
```

other cases just same as ruby json formatter.

full code to see [examples/log4r_logger](https://github.com/chadlwm/log_formatter/blob/master/examples/log4r_logger.rb)

## Test with Rspec

```
bundle exec rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at `https://github.com/chadlwm/log_formatter`. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

