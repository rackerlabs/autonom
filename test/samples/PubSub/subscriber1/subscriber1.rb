#class Subscriber1
  #include RrServicebus::Bus
  #attr_reader :var

#  handle(:critical) do
#    ## Business logic here.
#    warn "Subscriber1 critical metadata.content_type: #{metadata.content_type.inspect}"
#    warn "Subscriber1 critical payload: #{payload.inspect}"
#    method1
#    method2
#  end
#
#  handle(:critical) do
#    # Business logic here.
#    warn "Subscriber1 (handler2) critical metadata.content_type: #{metadata.content_type.inspect}"
#    warn "Subscriber1 (handler2) critical payload: #{payload.inspect}"
#    method1
#    method2
#  end
#
#  handle(:rate_limit) do
#    # Business logic here.
#    warn "Subscriber1 rate_limit metadata.content_type: #{metadata.content_type.inspect}"
#    warn "Subscriber1 rate_limit payload: #{payload.inspect}"
#    method1
#    method2
#  end
#
#  def initialize
#    @var = 'init'
#  end
#
#  def method1
#    warn "Some other method1 called!"
#    @some_other_method = true
#  end
#
#  def method2
#    warn "Some method2 called!"
#    warn @some_other_method.inspect
#    warn var.inspect
#  end
#end