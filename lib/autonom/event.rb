module Autonom
  module Event
    module Methods
      ;
    end

    def self.subscribe(object, publisher_signature, *methods, &block)
      publisher_signature = "anonymous" if publisher_signature.nil?
      autonom_data = object.instance_variable_get("@_autonom")
      channel = if autonom_data and autonom_data.has_key?(publisher_signature)
        autonom_data[publisher_signature][:channel]
      else
        EM::Channel.new.tap do |channel|
          object.extend(
            Module.new do
              methods.each do |method|
                meth = object.class.class_eval { instance_method(method) }
                define_method(method) do |*args|
                  channel.push([self, *args])
                  meth.bind(self).call(*args)
                end
              end
            end
          )
          object.extend Methods

          if autonom_data.nil?
            autonom_data = {publisher_signature => {:channel => channel, :subscribers => []}}
            object.instance_variable_set("@_autonom", autonom_data)
          else
            autonom_data[publisher_signature] = {:channel => channel, :subscribers => []}
          end
        end
      end

      channel.subscribe(block).tap do |sid|
        autonom_data[publisher_signature][:subscribers] << sid
      end
    end

#    {:notify_list_changed=>{:channel=>#<EventMachine::Channel:0x000001021d36e0
#@subs={1=>#<Proc:0x000001021d3758@/Volumes/Projects/autonom/test/lib/events_test.rb:33>, 2=>#<Proc:0x000001021d2f38@/Volumes/Projects/autonom/test/lib/events_test.rb:37>}, @uid=2>, :subscribers=>[1, 2]}}

    def self.unsubscribe(object, *publisher_signatures)
      autonom_data = object.instance_variable_get("@_autonom")

      publisher_signatures.each do |publisher_signature|
        channel = autonom_data[publisher_signature][:channel]
        subscriber = autonom_data[publisher_signature][:subscribers].pop
        channel.unsubscribe(subscriber)
      end
    end
  end
end
