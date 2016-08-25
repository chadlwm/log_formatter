require 'log4r'
require 'log_formatter'
require 'log_formatter/log4r_json_formatter'
include Log4r

logger = Log4r::Logger.new('Log4RTest')
# logger.outputters = Outputter.stdout
outputter = Log4r::StdoutOutputter.new(
  "console",
  :formatter => Log4r::JSONFormatter::Base.new
)
logger.add(outputter)

# plain initialize

logger.debug("Created logger")
logger.info("Program started")
logger.warn("Nothing to do!")
# {"message":"Created logger","log_level":"DEBUG","log_type":"Log4RTest","log_app":null,"log_timestamp":"2016-08-25T16:48:13+08:00"}
# {"message":"Program started","log_level":"INFO","log_type":"Log4RTest","log_app":null,"log_timestamp":"2016-08-25T16:48:13+08:00"}
# {"message":"Nothing to do!","log_level":"WARN","log_type":"Log4RTest","log_app":null,"log_timestamp":"2016-08-25T16:48:13+08:00"}

# initialize with app and ext info
logger2 = Log4r::Logger.new('Log4RTest')
outputter2 = Log4r::StdoutOutputter.new(
  "console",
  :formatter => Log4r::JSONFormatter::Base.new('app', {'source': 'examples'})
)
logger2.add(outputter2)

logger2.debug("Created logger")
logger2.info("Program started")
logger2.warn("Nothing to do!")
# {"source":"examples","message":"Created logger","log_level":"DEBUG","log_type":"Log4RTest","log_app":"app","log_timestamp":"2016-08-25T17:02:37+08:00"}
# {"source":"examples","message":"Program started","log_level":"INFO","log_type":"Log4RTest","log_app":"app","log_timestamp":"2016-08-25T17:02:37+08:00"}
# {"source":"examples","message":"Nothing to do!","log_level":"WARN","log_type":"Log4RTest","log_app":"app","log_timestamp":"2016-08-25T17:02:37+08:00"}

logger3 = Log4r::Logger.new('Log4RTest')
outputter3 = Log4r::StdoutOutputter.new(
  "console",
  :formatter => Log4r::JSONFormatter::Base.new('app', {'source': 'examples'})
)
logger3.add(outputter3)

logger3.debug({data: "Created logger"})
logger3.info({data: "Program started"})
logger3.warn({data: "Nothing to do!"})
# {"source":"examples","data":"Created logger","log_level":"DEBUG","log_type":"Log4RTest","log_app":"app","log_timestamp":"2016-08-25T17:03:48+08:00"}
# {"source":"examples","data":"Program started","log_level":"INFO","log_type":"Log4RTest","log_app":"app","log_timestamp":"2016-08-25T17:03:48+08:00"}
# {"source":"examples","data":"Nothing to do!","log_level":"WARN","log_type":"Log4RTest","log_app":"app","log_timestamp":"2016-08-25T17:03:48+08:00"}


logger4 = Log4r::Logger.new('Log4RTest')
json_formatter4 = Log4r::JSONFormatter::Base.new('app', {'source': 'examples'}) do |config|
  config[:level] = :cus_level
  config[:type] = :cus_type
  config[:app] = :cus_app
  config[:timestamp] = :cus_timestamp
end
outputter4 = Log4r::StdoutOutputter.new(
  "console",
  :formatter => json_formatter4
)
logger4.add(outputter4)

logger4.debug({data: "Created logger", autho: 'chad'})
logger4.info({data: "Program started", autho: 'chad'})
logger4.warn({data: "Nothing to do!", autho: 'chad'})
# {"source":"examples","data":"Created logger","autho":"chad","cus_level":"DEBUG","cus_type":"Log4RTest","cus_app":"app","cus_timestamp":"2016-08-25T17:06:06+08:00"}
# {"source":"examples","data":"Program started","autho":"chad","cus_level":"INFO","cus_type":"Log4RTest","cus_app":"app","cus_timestamp":"2016-08-25T17:06:06+08:00"}
# {"source":"examples","data":"Nothing to do!","autho":"chad","cus_level":"WARN","cus_type":"Log4RTest","cus_app":"app","cus_timestamp":"2016-08-25T17:06:06+08:00"}
