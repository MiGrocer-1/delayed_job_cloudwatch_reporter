require 'delayed_job_cloudwatch_reporter/store'
require 'delayed_job_cloudwatch_reporter/reporter'

module DelayedJobCloudwatchReporter
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      store = Store.instance
      Reporter.start(store)

      @app.call(env)
    end
  end
end