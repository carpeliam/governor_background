module GovernorBackground
  module Delayed
    class Job
      attr_reader :created_at
      def initialize(job)
        @id = job.try(:id)
        @created_at = Time.now
      end
      
      def successful?
        delayed_job.nil?
      end
      
      def status
        job = Delayed::Job.find_by_id(@id)
        return :success if job.nil?
        # etc
      end
      
      private
      def delayed_job
        Delayed::Job.find_by_id(@id)
      end
    end
  end
end