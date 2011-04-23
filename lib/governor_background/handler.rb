module GovernorBackground
  class Handler
    class << self
      def run_in_background(object, method)
        job = if delayed_job?
          Delayed::Job.new(::Delayed::Job.enqueue(Delayed::Performer.new(object, method)))
        elsif resque?
          resource_key = object.class.name.tableize.to_sym
          if resque_with_status?
            require 'resque/performer_with_state'
            Resque::Job.new(Resque::PerformerWithState.create(:resource => resource_key, :id => id, :method => method))
          else
            Resque.enqueue(Resque::Performer, resource_key, id, method)
            nil # not much use in holding on to state
          end
        end
        GovernorBackground::JobManager.add(job) unless job.blank?
      end
      
      private
      def delayed_job?
        defined? ::Delayed::Job
      end

      def resque?
        defined? ::Resque
      end
      
      def resque_with_status?
        defined? ::Resque::Status
      end
    end
  end
end