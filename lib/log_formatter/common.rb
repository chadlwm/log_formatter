module LogFormatter::Common
  def build_event(message, severity, time, progname)
    data = message
    if data.is_a?(String) && data.start_with?('{'.freeze)
      data = (JSON.parse(message) rescue nil) || message
    end

    event = case data
              when Hash
                data
              else
                {"message".freeze => msg2str(data)}
            end

    event[@config[:level].freeze] ||= severity if @config[:level]
    event[@config[:type].freeze] = progname if @config[:type]
    event[@config[:app].freeze] = @app if @config[:app]
    event[@config[:timestamp].freeze] = current_time(time).iso8601 if @config[:timestamp]
    "#{@ext.merge(event).to_json}\n"
  end

  def msg2str(msg)
    case msg
    when ::String
      msg.gsub("\n", "\t")
    when ::Exception
      "#{ msg.message } (#{ msg.class })\t" <<
        (msg.backtrace || []).join("\t")
    else
      msg.inspect
    end
  end

  def current_time(time)
    return time if time
    Time.respond_to?(:current) ? Time.current : Time.now
  end
end