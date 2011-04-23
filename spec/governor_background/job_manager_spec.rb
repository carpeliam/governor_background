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
  end
end