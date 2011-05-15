require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe GovernorBackground do
  it "passes arguments to the handler" do
    GovernorBackground::Handler.expects(:run_in_background).with(:job_name, 1, 2, 3)
    GovernorBackground.run(:job_name, 1, 2, 3)
  end
  
  it "registers jobs" do
    block = Proc.new do |a, b, c|
    end
    GovernorBackground.register(:job_name, &block)
    GovernorBackground.retrieve(:job_name).should == block
  end
end
