require 'singleton'
require 'delayed_job_cloudwatch_reporter/config'
require 'delayed_job_cloudwatch_reporter/cloudwatch_report_api'

module DelayedJobCloudwatchReporter
  class Reporter
    include Singleton

    def self.start(store)
      instance.start!(store) unless instance.started?
    end

    def start!(store)
      @started = true
      @adapters = Config::ADAPTERS.select(&:enabled?)

      Thread.new do
        puts "checking for leader lock"
        begin
          Timeout::timeout(60*10) {
            with_leader_lock do
              puts "got `leader lock"
              loop do
                multiplier = 1 - (rand / 4)
                sleep 10 * multiplier

                begin
                  print "collecting data"
                  @adapters.map { |a| a.collect!(store) }
                  report!(store)
                rescue => ex
                  puts "Exception: #{ex.message}"
                  puts ex.backtrace
                end
              end
            end
            puts "killed leader lock"
          }
        rescue => e
          puts e.message
          puts e.backtrace
        ensure
          @started = false
        end
      end
    end

    def with_leader_lock
      if defined?(Redlock::Client)
        client
        redis.lock("reporter_leader_lock") do

        end
      elsif defined?(ActiveRecord::Base.connection.adapter_name) && ActiveRecord::Base.connection.adapter_name == "PostgreSQL"
        ActiveRecord::Base.transaction do
          ActiveRecord::Base.connection.execute("SELECT pg_advisory_xact_lock(#{Zlib.crc32("reporter_leader_lock") & 0x7fffffff})")
          yield
        end
      end
    end

    def started?
      @started
    end


    def report!(store)
      measurements = store.pop_measurements

      if measurements.any?
        CloudwatchReportApi.report_metrics!(measurements)
      end
    end


  end
end