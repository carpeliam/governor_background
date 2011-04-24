module GovernorBackground
  class Handler
    class << self
      def run_in_background(object, method)
        job = if delayed_job?
          Delayed::Job.new(object, method, ::Delayed::Job.enqueue(Delayed::Performer.new(object, method)))
        elsif resque?
          resource_key, id = object.class.name.tableize.to_sym, object.id
          if resque_with_status?
            require File.expand_path('../resque/performer_with_state',  __FILE__)
            Resque::Job.new(object, method, Resque::PerformerWithState.create(:resource => resource_key, :id => id, :method_name => method))
          else
            ::Resque.enqueue(Resque::Performer, resource_key, id, method)
            nil # not much use in holding on to state if we can't track it
          end
        end
        JobManager.add(job) unless job.blank?
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