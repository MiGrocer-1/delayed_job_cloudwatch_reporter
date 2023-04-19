require 'delayed_job_cloudwatch_reporter/middleware'

module DelayedJobCloudwatchReporter
  class Railtie < Rails::Railtie
    # include Logger

    initializer "delayed_job_cloudwatch_reporter.middleware" do |app|
      puts "Preparing middleware"
      app.middleware.insert_before Rack::Runtime, Middleware
    end

  end
end
