require 'spec_helper'

module GovernorBackground
  class Handler
    cattr_writer :use_resque # programmatically prefer resque
    @@use_redis = false
    class << self
      private
      def delayed_job?
        defined?(::Delayed::Job) && !@@use_resque
      end
    end
  end
  
  module Resque
    class Job
      attr_reader :id, :created_at # make ID accessible for testing
      def initialize(job_id)
        @id = job_id
        @created_at = Time.now
      end
    end
  end
  
  describe Handler do
    before do
      JobManager.jobs.clear
      @article = Factory(:article, :author => Factory(:user))
    end
    
    it "adds delayed jobs successfully" do
      expect {
        Handler.run_in_background(@article, :post)
      }.to change { ::Delayed::Job.count }.by 1
    end
    
    it "adds resque jobs successfully" do
      Handler.use_resque = true
      Handler.run_in_background(@article, :post)
      id = JobManager.jobs.first.id
      Resque::PerformerWithState.should have_queued(id, {:resource => :articles, :id => @article.id, :method => :post}).in(:governor)
    end
  end
end