require 'logger'
require 'json'
require 'time'
require File.expand_path('../common', __FILE__)

module Ruby
  module JSONFormatter
    class Base < ::Logger::Formatter
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
      end

      def call(severity, time, progname, message)
        @event = build_event(message, severity, time, progname)
      end
    end
  end
end