module GovernorBackground
  module Controllers
    module Methods
      def self.included(c)
        c.before_filter :show_recent_statuses
      end
      
      def show_recent_statuses
        finished_jobs = GovernorBackground::JobManager.finished_jobs
        unless finished_jobs.blank?
          flash[:governor_background] = finished_jobs.map do |job|
            [job.status, t("#{job.name}_#{job.status}", :message => job.message, :default => [job.status, job.status.to_sym], :scope => :governor_background)]
          end
        end
      end
    end
  end
end