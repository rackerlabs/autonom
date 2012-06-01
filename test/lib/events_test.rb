$:.unshift File.expand_path('../../..', __FILE__)
require 'test/test_helper'
require 'eventmachine'

describe Autonom::Event do
  subject { Array.new }

  it "subscribes to an events" do
    EM.run do
      Autonom::Event.subscribe(subject, :notify_list_changed, :push) do |sender, payload|
        puts "Sender Class: #{sender.class} Payload: #{payload.inspect}"
      end

      proc { subject.push "72 Bricks" }.must_output "Sender Class: Array Payload: \"72 Bricks\"\n"

      EM.stop
    end
  end

  it "handles multiple methods patched" do
    EM.run do
      Autonom::Event.subscribe(subject, :notify_list_changed, :push, :pop) do |sender, payload|
        puts "Sender Class: #{sender.class} Payload: #{payload.inspect}"
      end

      proc { subject.pop; subject.push "72 Bricks"}.
        must_output "Sender Class: Array Payload: nil\nSender Class: Array Payload: \"72 Bricks\"\n"
      EM.stop
    end
  end

  it "uses an anonymous publisher_signature when none supplied." do
      EM.run do
        Autonom::Event.subscribe(subject, nil, :pop) do |sender, payload|
          puts "Sender Class: #{sender.class} Payload: #{payload.inspect}"
        end

        proc { subject.pop }.
          must_output "Sender Class: Array Payload: nil\n"
        EM.stop
      end
    end

  it "handles multiple subscriptions" do
    EM.run do
      Autonom::Event.subscribe(subject, :notify_list_changed, :push) do |sender, payload|
        puts "Subscriber1: Sender: #{sender.inspect} Payload: #{payload.inspect}"
      end

      Autonom::Event.subscribe(subject, :notify_list_changed, :push) do |sender, payload|
        puts "Subscriber2: Sender: #{sender.inspect} Payload: #{payload.inspect}"
      end

      proc { subject.push "72 Bricks" }.
        must_output "Subscriber1: Sender: [] Payload: \"72 Bricks\"\nSubscriber2: Sender: [] Payload: \"72 Bricks\"\n"

      EM.stop
    end
  end


  it "only extends the object, not the class" do
    proc { subject.push "72 Bricks" }.must_output nil
  end

  it "unsubscribes from single event subscriptions" do
    EM.run do
      Autonom::Event.subscribe(subject, :notify_list_changed, :push) do |sender, payload|
        puts "Subscriber1: Sender: #{sender.inspect} Payload: #{payload.inspect}"
      end

      capture_io { subject.push "72 Bricks" }.first.wont_be_empty

      Autonom::Event.unsubscribe(subject, :notify_list_changed)

      capture_io { subject.push "72 Bricks" }.first.must_be_empty

      EM.stop
    end
  end

  it "unsubscribes from multiple event subscriptions" do
    EM.run do
      Autonom::Event.subscribe(subject, :notify_list_changed, :push) do |sender, payload|
        puts "Subscriber1: Sender Class: #{sender.class} Payload: #{payload.inspect}"
      end

      Autonom::Event.subscribe(subject, :notify_list_changed, :push) do |sender, payload|
        puts "Subscriber2: Sender Class: #{sender.class} Payload: #{payload.inspect}"
      end

      capture_io { subject.push "72 Bricks" }.first.wont_be_empty

      Autonom::Event.unsubscribe(subject, :notify_list_changed)

      proc { subject.push "72 Bricks" }.
        must_output "Subscriber1: Sender Class: Array Payload: \"72 Bricks\"\n"

      Autonom::Event.unsubscribe(subject, :notify_list_changed)

      EM.stop
    end
  end
end