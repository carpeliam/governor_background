require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe GovernorBackground do
  it "passes arguments to the handler" do
    @article = Factory(:article, :author => Factory(:user))
    GovernorBackground::Handler.expects(:run_in_background).with(@article, :some_method, [1, 2, 3])
    @article.send(:run_in_background, :some_method, 1, 2, 3)
  end
end
