module GovernorBackground
  class Handler
    class << self
      def run_in_background(object, method)
        if delayed_job?
          Delayed::Job.enqueue GovernorBackground::DelayedJob.new(object, method)
        elsif resque?
          Resque.enqueue(GovernorBackend::Resque, object, method)
        end
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