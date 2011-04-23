require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe GovernorBackground do
  it "adds #run_in_background to Article" do
    Article.private_instance_methods.include? 'run_in_background'
  end
end
