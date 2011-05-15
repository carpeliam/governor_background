module GovernorBackground
  class Handler
    class << self
      def run_in_background(job_name, *arguments)
        job = if delayed_job?
          Delayed::Job.new(job_name, ::Delayed::Job.enqueue(Delayed::Performer.new(job_name, arguments)))
        elsif resque?
          resque_args = arguments.map do |arg|
            arg.is_a?(ActiveRecord::Base) ? Resque::Resource.new(arg) : arg
          end
          if resque_with_status?
            Resque::Job.new(job_name, Resque::PerformerWithState.create(:job_name => job_name, :arguments => resque_args))
          else
            ::Resque.enqueue(Resque::Performer, job_name, *resque_args)
            nil # not much use in holding on to state if we can't track it
          end
        end
        JobManager.add(job) if job
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