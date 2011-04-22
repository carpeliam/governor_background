module GovernorBackground
  class Handler
    class << self
      def run_in_background(object, method)
        job = if delayed_job?
          GovernorBackground::Delayed::JobState.new(Delayed::Job.enqueue(GovernorBackground::Delayed::Job.new(object, method)))
        elsif resque?
          GovernorBackground::Resque::JobState.new(Resque.enqueue(GovernorBackground::Resque::Job, object, method))
        end
        GovernorBackground::JobManager.add_job job
      end
      
      private
      def delayed_job?
        defined? ::Delayed::Job
      end

      def resque?
        defined? ::Resque
      end
    end
  end
end