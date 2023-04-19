module DelayedJobCloudwatchReporter
end


require 'delayed_job_cloudwatch_reporter/railties' if defined?(Rails::Railtie) && Rails::Railtie.respond_to?(:initializer)