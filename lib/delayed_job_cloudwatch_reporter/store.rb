require 'delayed_job_cloudwatch_reporter/measurement'

module DelayedJobCloudwatchReporter
  class Store
    include Singleton

    attr_reader :measurements

    def initialize
      @measurements = []
    end

    def push(time, value, queue_name = nil)
      @measurements << Measurement.new(time, value, queue_name)
    end

    def pop_measurements
      measurements_list = []

      while measurement = @measurements.shift
        measurements_list << measurement
      end

      measurements_list
    end

  end
end
