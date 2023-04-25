module DelayedJobCloudwatchReporter
end


if defined?(Rails::Railtie) && Rails::Railtie.respond_to?(:initializer) && ENV["ENABLE_DELAYED_JOB_CLOUDWATCH_REPORTER"] == 'true'
  require 'delayed_job_cloudwatch_reporter/railties'
else
  puts "delayed job cloudwatch reporter enabled: #{ENV["ENABLE_DELAYED_JOB_CLOUDWATCH_REPORTER"] || false}"
end