module Autonom
  module Message
    def self.included(mod)
      mod.send :include, Virtus
      Registry.message_types.push mod
    end
  end
end