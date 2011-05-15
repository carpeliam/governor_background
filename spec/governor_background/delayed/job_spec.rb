require 'spec_helper'

module GovernorBackground
  module Delayed
    describe Job do
      let(:article) { Factory(:article, :author => Factory(:user)) }
      it "has a status of queued if it's not currently locked" do
        job = get_job_for stub(:id => article.id, :locked_at => nil)
        job.should be_queued
        job.status.should == 'queued'
      end
      
      it "has a status of working if it's currently locked and being run and hasn't failed" do
        job = get_job_for stub(:id => article.id, :run_at => Time.now, :locked_at => Time.now, :failed? => nil)
        job.should be_working
        job.status.should == 'working'
      end
      
      it "has a status of completed if it can't be found" do
        ::Delayed::Job.expects(:find_by_id).with(article.id).at_least_once.returns nil
        job = Job.new(:job_name, stub(:id => article.id))
        job.should be_completed
        job.status.should == 'completed'
      end
      
      it "has a status of failed if it's marked as failed and has been run as many times as possible" do
        job = get_job_for stub(:id => article.id, :run_at => Time.now, :locked_at => Time.now, :failed? => Time.now, :attempts => ::Delayed::Worker.max_attempts)
        job.should be_failed
        job.status.should == 'failed'
      end
      
      it "parses the message from DelayedJob" do
        error_msg = "{DelayedJob error messages can be on
        multiple lines"
        job = get_job_for stub(:id => article.id, :run_at => Time.now, :locked_at => Time.now,
          :failed? => Time.now, :attempts => ::Delayed::Worker.max_attempts, :last_error => error_msg)
        job.message.should == "DelayedJob error messages can be on"
      end
      
      private
      def get_job_for(delayed_job)
        ::Delayed::Job.expects(:find_by_id).with(delayed_job.id).at_least_once.returns delayed_job
        Job.new(:job_name, delayed_job)
      end
    end
  end
end