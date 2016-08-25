require 'log4r'
require 'json'
require 'time'
require File.expand_path('../common', __FILE__)

module Log4r::JSONFormatter
  class Base < Log4r::BasicFormatter
    include LogFormatter::Common

    def initialize(app = nil, ext = {})
      @app = app
      @ext = ext.is_a?(Hash) ? ext : {}
      @config = {
        level: :log_level,
        type: :log_type,
        app: :log_app,
        timestamp: :log_timestamp
      }

      yield @config if block_given?

      super()
    end

    def format(event)
      @event = build_event(event.data, Log4r::LNAMES[event.level], nil, event.name)
    end
  end
end