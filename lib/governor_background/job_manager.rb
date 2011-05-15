module GovernorBackground
  # Tracks the progress of jobs, enables reporting of finished jobs, and
  # cleans stale jobs.
  class JobManager
    @@finished_statuses = %w(completed failed killed).freeze
    cattr_reader :jobs
    class << self
      @@jobs = []
      # Adds a job to the queue.
      def add(job)
        @@jobs << job
      end
      
      # Purges any jobs that are older than the specified time. This only
      # removes the job wrapper from memory, it does not cancel a job if it is
      # still running.
      def clean(time = 1.day.ago)
        @@jobs.reject!{|j| j.created_at < time}
      end
      
      # Returns and purges any jobs that have either been completed, failed,
      # or killed.
      def finished_jobs
        finished_jobs = @@jobs.select{|j| @@finished_statuses.include? j.status }
        @@jobs -= finished_jobs
        return finished_jobs
      end
    end
  end
end