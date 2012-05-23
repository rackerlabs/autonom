module Autonom
  class Registry
    class << self
      attr_reader :message_handlers, :message_types, :wants_to_run_at_startup, :wants_to_run_when_the_bus_starts_up
    end
    @message_handlers = Hash.new.with_indifferent_access
    @message_types = []
    @wants_to_run_at_startup = []
    @wants_to_run_when_the_bus_starts_up = []
  end
end
