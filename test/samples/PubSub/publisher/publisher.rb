class Publisher
  #include RrServicebus::Bus

  #i_want_to_run_at_startup

  def run
    EventMachine::add_periodic_timer(0.1) do
      message = Critical.new
      message.data = 'This is a critical message'
      warn "Publishing: #{message.inspect}"
      publish message

      message = RateLimit.new
      message.data = 'This is a rate limiting message message'
      warn "Publishing: #{message.inspect}"

      publish message
    end
  end

  def stop
  end
end
