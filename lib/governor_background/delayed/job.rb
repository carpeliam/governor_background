module GovernorBackground
  module Delayed
    class Job
      attr_reader :resource, :method_name, :created_at
      def initialize(resource, method_name, job)
        @resource = resource
        @method_name = method_name
        @id = job.try(:id)
        @created_at = Time.now
      end
      
      def queued?
        job_queued?
      end
      
      def working?
        job_working?
      end
      
      def completed?
        job_completed?
      end
      
      def failed?
        job_failed?
      end
      
      def killed?
        # as far as i know, you can't tell if a job has been killed
        false
      end
      
      def status
        job = delayed_job
        return 'queued' if job_queued?(job)
        return 'working' if job_working?(job)
        return 'completed' if job_completed?(job)
        return 'failed' if job_failed?(job)
        raise 'Status unknown.' # we should never get here.
      end
      
      def message
        (job = delayed_job) && job.failed? ?
          job.last_error.lines.first.chomp.gsub(/^\{/, '') :
          status.humanize
      end
      
      private
      def delayed_job
        ::Delayed::Job.find_by_id(@id)
      end
      
      def job_queued?(job = delayed_job)
        job && !job.locked_at
      end
      
      def job_working?(job = delayed_job)
        job && job.run_at && job.locked_at && !job.failed?
      end
      
      def job_completed?(job = delayed_job)
        job.nil?
      end
      
      def job_failed?(job = delayed_job)
        job && job.failed? && job.attempts == ::Delayed::Worker.max_attempts
      end
    end
  end
end