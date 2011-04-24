module GovernorBackground
  class JobManager
    @@finished_statuses = %w(completed failed killed).freeze
    cattr_reader :jobs
    class << self
      @@jobs = []
      def add(job)
        @@jobs << job
      end
      
      def clean(time = 1.day.ago)
        @@jobs.reject!{|j| j.created_at < time}
      end
      
      def finished_jobs
        finished_jobs = @@jobs.select{|j| @@finished_statuses.include? j.status }
        @@jobs -= finished_jobs
        return finished_jobs
      end
    end
  end
end