module LogFormatter::Common
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