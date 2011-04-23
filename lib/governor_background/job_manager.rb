module GovernorBackground
  class JobManager
    cattr_reader :jobs
    class << self
      @@jobs = []
      def add(job)
        @@jobs << job
      end
      
      def clean(time = 1.day.ago)
        @@jobs.reject!{|j| j.created_at < time}
      end
    end
  end
end