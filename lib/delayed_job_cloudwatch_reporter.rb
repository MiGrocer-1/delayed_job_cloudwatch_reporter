module DelayedJobCloudwatchReporter
end


if defined?(Rails::Railtie) && Rails::Railtie.respond_to?(:initializer) && ENV.fetch("ENABLE_DELAYED_JOB_CLOUDWATCH_REPORTER") == 'true'
  require 'delayed_job_cloudwatch_reporter/railties'
end