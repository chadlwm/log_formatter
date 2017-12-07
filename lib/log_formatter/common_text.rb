module LogFormatter::Common::Text
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
    log_msg = []
    @ext.merge(event).each do |k, v|
      log_msg << "#{k}:#{v}"
    end
    log_msg.join("\t")+"\n"
  end
end