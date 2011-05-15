module GovernorBackground
  module Resque
    # A wrapper around a Resque job.
    class Job
      attr_reader :name, :created_at
      # Initializes the job with a job name (passed from
      # <code>GovernorBackground.run</code>) and a unique identifier for the
      # Resque job.
      def initialize(name, job_id)
        @name = name
        @id = job_id
        @created_at = Time.now
      end
      
      # Returns the status of the job, which can be any of the boolean methods
      # or +unknown+.
      def status
        (job = resque_status) ? job.status : 'unknown'
      end
      
      # Returns true if this job is currently waiting in the queue, false
      # otherwise.
      def queued?
        proxy :queued?
      end
      
      # Returns true if this job is currently being processed, false
      # otherwise.
      def working?
        proxy :working?
      end
      
      # Returns true if this job has been completed, false otherwise.
      def completed?
        proxy :completed?
      end
      
      # Returns true if this job has failed, false otherwise.
      def failed?
        proxy :failed?
      end
      
      # Returns true if this job has been killed, false otherwise.
      def killed?
        proxy :killed?
      end
      
      # Returns a human readable message describing the status.
      def message
        proxy :message, ''
      end
      
      private
      def resque_status
        ::Resque::Status.get(@id)
      end
      
      def proxy(method, default=false)
        resque_status.try(method) or default
      end
    end
  end
end