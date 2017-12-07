require 'logger'
require 'log_formatter'
require 'log_formatter/ruby_text_formatter'

logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG

# plain initialize
logger.formatter =  Ruby::TextFormatter::Base.new

logger.debug("Created logger")
logger.info("Program started")
logger.warn("Nothing to do!")
# message:Created logger	log_level:DEBUG	log_type:	log_app:	log_timestamp:2017-12-07T17:25:18+08:00
# message:Program started	log_level:INFO	log_type:	log_app:	log_timestamp:2017-12-07T17:25:18+08:00
# message:Nothing to do!	log_level:WARN	log_type:	log_app:	log_timestamp:2017-12-07T17:25:18+08:00

# initialize with app and ext info
logger.formatter =  Ruby::TextFormatter::Base.new('app', {'source': 'examples'})

logger.debug("Created logger")
logger.info("Program started")
logger.warn("Nothing to do!")
# source:examples	message:Created logger	log_level:DEBUG	log_type:	log_app:app	log_timestamp:2017-12-07T17:25:56+08:00
# source:examples	message:Program started	log_level:INFO	log_type:	log_app:app	log_timestamp:2017-12-07T17:25:56+08:00
# source:examples	message:Nothing to do!	log_level:WARN	log_type:	log_app:app	log_timestamp:2017-12-07T17:25:56+08:00

# log hash
logger.formatter =  Ruby::TextFormatter::Base.new('app', {'source': 'examples'})

logger.debug({data: "Created logger"})
logger.info({data: "Program started"})
logger.warn({data: "Nothing to do!"})
# source:examples	data:Created logger	log_level:DEBUG	log_type:	log_app:app	log_timestamp:2017-12-07T17:25:56+08:00
# source:examples	data:Program started	log_level:INFO	log_type:	log_app:app	log_timestamp:2017-12-07T17:25:56+08:00
# source:examples	data:Nothing to do!	log_level:WARN	log_type:	log_app:app	log_timestamp:2017-12-07T17:25:56+08:00

# log with custome key instead of default keys
logger.formatter =  Ruby::TextFormatter::Base.new('app', {'source': 'examples'}) do |config|
  config[:level] = :cus_level
  config[:type] = :cus_type
  config[:app] = :cus_app
  config[:timestamp] = :cus_timestamp
end

logger.debug({data: "Created logger"})
logger.info({data: "Program started"})
logger.warn({data: "Nothing to do!"})
# source:examples	data:Created logger	cus_level:DEBUG	cus_type:	cus_app:app	cus_timestamp:2017-12-07T17:25:56+08:00
# source:examples	data:Program started	cus_level:INFO	cus_type:	cus_app:app	cus_timestamp:2017-12-07T17:25:56+08:00
# source:examples	data:Nothing to do!	cus_level:WARN	cus_type:	cus_app:app	cus_timestamp:2017-12-07T17:25:56+08:00

# log to disable some auto generate keys by setting to fasle
logger.formatter =  Ruby::TextFormatter::Base.new('app', {'source': 'examples'}) do |config|
  config[:level] = false
  config[:type] = false
  config[:app] = :cus_app
  config[:timestamp] = false
end

logger.debug({data: "Created logger"})
logger.info({data: "Program started"})
logger.warn({data: "Nothing to do!"})
# source:examples	data:Created logger	cus_app:app
# source:examples	data:Program started	cus_app:app
# source:examples	data:Nothing to do!	cus_app:ap