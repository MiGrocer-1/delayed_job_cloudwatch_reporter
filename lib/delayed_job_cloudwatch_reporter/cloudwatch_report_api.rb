require 'aws-sdk'

module DelayedJobCloudwatchReporter
  class CloudwatchReportApi

    @client = nil

    def self.report_metrics!(measurements)
      @client ||= Aws::CloudWatch::Client.new

      @client.put_metric_data({
                                namespace: ENV.fetch("CLOUDWATCH_NAMESPACE") || "Queue Count",
                                metric_data: measurements.map do |measurement|
                                  {
                                    metric_name: measurement.queue_name,
                                    timestamp: measurement.time,
                                    value: measurement.value,
                                    unit: "Milliseconds"
                                  }
                                end
                              })
    end

  end
end