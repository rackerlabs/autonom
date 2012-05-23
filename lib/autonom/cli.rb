require 'autonom'
require 'thor'
require 'daemons'

module Autonom
  class CLI < Thor

    desc 'start AC', 'Start Component'

    method_option :ontop, :aliases => "-t", :type => :boolean, :default => false, :desc => "Run program ontop (foreground)"
    method_option :backtrace, :aliases => "-b", :type => :boolean, :default => false, :desc => "Something about backtraces"
    method_option :monitor, :aliases => "-m", :type => :boolean, :default => false, :desc => "Something about monitors"

    def start(component)
      File.exists?(component) or raise "Component #{component} does not exist"

      require_all 'messages'
      require_all component

      Daemons.run_proc(component, {
        :app_name => component,
        :ARGV => %w(start),
        :dir_mode => :script,
        :dir => component,
        :multiple => true,
        :ontop => options['ontop'],
        :mode => :exec,
        :backtrace => options['backtrace'],
        :monitor => options['monitor']
      }) do
        EventMachine.run do

        end
      end
    end

    desc 'stop AC', 'Stop Component'
    def stop(component)
      Dir.glob("#{component}/*.pid") do |file|
        pid = File.open(file).gets.chomp.to_i
        warn "Killing #{pid}"
        Process.kill("TERM", pid)
      end
    end
  end
end