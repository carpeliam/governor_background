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
      attr_reader :resource, :method_name, :id, :created_at # make ID accessible for testing
      def initialize(resource, method_name, job_id)
        @resource = resource
        @method_name = method_name
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
    
    context "delayed_job" do
      it "adds jobs successfully" do
        expect {
          Handler.run_in_background(@article, :post)
        }.to change { ::Delayed::Job.count }.by 1
      end
      
      it "handles any number of arguments" do
        Handler.run_in_background(@article, :post, 1, 2, 3)
        performer = YAML.load ::Delayed::Job.first.handler
        performer.arguments.should == [1, 2, 3]
      end
    end
    
    context "resque" do
      it "adds jobs successfully" do
        Handler.use_resque = true
        Handler.run_in_background(@article, :post)
        id = JobManager.jobs.first.id
        Resque::PerformerWithState.should have_queued(id, {:resource => :articles, :id => @article.id, :method_name => :post, :arguments => []}).in(:governor)
      end
    
      it "can accept any number of arguments" do
        Handler.use_resque = true
        Handler.run_in_background(@article, :post, 1, 2, 3)
        id = JobManager.jobs.first.id
        Resque::PerformerWithState.should have_queued(id, {:resource => :articles, :id => @article.id, :method_name => :post, :arguments => [1, 2, 3]}).in(:governor)
      end
    end
  end
end