require 'spec_helper'

module GovernorBackground
  module Delayed
    describe Job do
      it "has a status of queued if it's not currently locked" do
        job = get_job_for stub(:id => 1, :locked_at => nil)
        job.should be_queued
        job.status.should == 'queued'
      end
      
      it "has a status of working if it's currently locked and being run and hasn't failed" do
        job = get_job_for stub(:id => 1, :run_at => Time.now, :locked_at => Time.now, :failed? => nil)
        job.should be_working
        job.status.should == 'working'
      end
      
      it "has a status of completed if it can't be found" do
        dj = stub(:id => 1)
        Delayed::Job.expects(:find_by_id).with(dj.id).at_least_once.returns nil
        job = Job.new(dj)
        job.should be_completed
        job.status.should == 'completed'
      end
      
      it "has a status of failed if it's marked as failed and has been run as many times as possible" do
        job = get_job_for stub(:id => 1, :run_at => Time.now, :locked_at => Time.now, :failed? => Time.now, :attempts => ::Delayed::Worker.max_attempts)
        job.should be_failed
        job.status.should == 'failed'
      end
      
      private
      def get_job_for(delayed_job)
        Delayed::Job.expects(:find_by_id).with(delayed_job.id).at_least_once.returns delayed_job
        Job.new(delayed_job)
      end
    end
  end
end