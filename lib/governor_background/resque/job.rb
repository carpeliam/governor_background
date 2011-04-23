module Governor
  module Resque
    class Job
      attr_reader :created_at
      def initialize(job_id)
        @id = job_id
        @created_at = Time.now
      end
      
    end
  end
end