module GovernorBackground
  class JobManager
    class << self
      @jobs = []
      def add_job(job)
        @jobs << job
      end
    end
  end
end