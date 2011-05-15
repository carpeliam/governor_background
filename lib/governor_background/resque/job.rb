module GovernorBackground
  module Resque
    class Job
      attr_reader :name, :created_at
      def initialize(name, job_id)
        @name = name
        @id = job_id
        @created_at = Time.now
      end
      
      def status
        # if we can't find it, assume it's been killed (not really sure if this is the proper assumption)
        (job = resque_status) ? job.status : 'killed'
      end
      
      def queued?
        proxy :queued?
      end
      
      def working?
        proxy :working?
      end
      
      def completed?
        proxy :completed?
      end
      
      def failed?
        proxy :failed?
      end
      
      def killed?
        proxy :killed?
      end
      
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