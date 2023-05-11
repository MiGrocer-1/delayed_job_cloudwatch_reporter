

module DelayedJobCloudwatchReporter
  module Adapters
    class DelayedJob
      include Singleton

      attr_writer :queues

      def queues
        @queues ||= Set.new(['default'] | (ENV['QUEUES'] || "").split(","))
      end

      def enabled?
        if defined?(::Delayed::Job) && defined?(::Delayed::Backend::ActiveRecord)
          # logger.info "DelayedJob enabled (#{::ActiveRecord::Base.default_timezone})"
          true
        end
      end

      def collect!(store)
        t = Time.now.utc
        sql = <<~SQL.strip.gsub("\n", " ")
          SELECT COALESCE(queue, 'default'), min(run_at)
          FROM delayed_jobs
          WHERE locked_at IS NULL
          AND failed_at IS NULL
          GROUP BY queue
        SQL

        run_at_by_queue = Hash[ActiveRecord::Base.connection.select_rows(sql)]
        self.queues |= run_at_by_queue.keys

        queues.each do |queue|
          run_at = run_at_by_queue[queue]
          # DateTime.parse assumes a UTC string
          run_at = DateTime.parse(run_at) if run_at.is_a?(String)
          latency_ms = run_at ? ((t - run_at)*1000).ceil : 0
          latency_ms = 0 if latency_ms < 0

          store.push t, latency_ms, queue
        end
      end
    end
  end
end