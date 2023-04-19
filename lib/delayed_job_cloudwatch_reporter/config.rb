require 'delayed_job_cloudwatch_reporter/adapters/delayed_job'

module DelayedJobCloudwatchReporter
  class Config

    ADAPTERS = [
      Adapters::DelayedJob.instance
    ]

  end
end
