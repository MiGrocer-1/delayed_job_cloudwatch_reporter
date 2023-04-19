module DelayedJobCloudwatchReporter
  class Measurement < Struct.new(:time, :value, :queue_name)

    def initialize(time, value, queue_name = nil)
      super time, value, queue_name
    end
  end
end
