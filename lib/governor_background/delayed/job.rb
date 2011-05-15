module GovernorBackground
  module Delayed
    # A wrapper around ::Delayed::Job.
    class Job
      attr_reader :name, :created_at
      # Initializes the job with a job name (passed from
      # <code>GovernorBackground.run</code>) and the original delayed_job job.
      def initialize(name, job)
        @name = name
        @id = job.try(:id)
        @created_at = Time.now
      end
      
      # Returns true if this job is currently waiting in the queue, false
      # otherwise.
      def queued?
        job_queued?
      end
      
      # Returns true if this job is currently being processed, false
      # otherwise.
      def working?
        job_working?
      end
      
      # Returns true if this job has been completed, false otherwise.
      def completed?
        job_completed?
      end
      
      # Returns true if this job has failed, false otherwise.
      def failed?
        job_failed?
      end
      
      # Always returns false; as far as I know, you can't tell if a job has
      # been killed.
      def killed?
        false
      end
      
      # Returns the status of the job, which can be any of the boolean methods
      # or +unknown+.
      def status
        job = delayed_job
        return 'queued' if job_queued?(job)
        return 'working' if job_working?(job)
        return 'completed' if job_completed?(job)
        return 'failed' if job_failed?(job)
        return 'unknown'
      end
      
      # Returns a human readable message describing the status. If the job has
      # failed, this will include the error message, otherwise the status
      # itself will be returned.
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