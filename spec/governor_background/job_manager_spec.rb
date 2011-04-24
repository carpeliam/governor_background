require 'spec_helper'

module GovernorBackground
  describe JobManager do
    before(:each) do
      JobManager.jobs.clear
    end
    it "keeps track of jobs" do
      job = mock()
      JobManager.add(job)
      JobManager.jobs.size.should == 1
    end
    
    it "can remove old jobs" do
      JobManager.add(mock(:created_at => 2.days.ago))
      JobManager.add(mock(:created_at => 3.hours.ago))
      JobManager.add(mock(:created_at => Time.now))
      JobManager.jobs.size.should == 3
      JobManager.clean
      JobManager.jobs.size.should == 2
    end
    
    it "can remove old jobs specified by time" do
      JobManager.add(mock(:created_at => 2.days.ago))
      JobManager.add(mock(:created_at => 3.hours.ago))
      JobManager.add(mock(:created_at => Time.now))
      JobManager.jobs.size.should == 3
      JobManager.clean(2.hours.ago)
      JobManager.jobs.size.should == 1
    end
    
    it "will return all finished jobs and remove them from the list" do
      JobManager.add(queued    = mock('queued',    :status => 'queued'))
      JobManager.add(working   = mock('working',   :status => 'working'))
      JobManager.add(completed = mock('completed', :status => 'completed'))
      JobManager.add(failed    = mock('failed',    :status => 'failed'))
      JobManager.add(killed    = mock('killed',    :status => 'killed'))
      
      JobManager.jobs.size.should == 5
      JobManager.finished_jobs.should == [completed, failed, killed]
      JobManager.jobs.size.should == 2
    end
  end
end