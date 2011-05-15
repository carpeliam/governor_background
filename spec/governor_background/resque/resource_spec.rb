require 'spec_helper'

module GovernorBackground
  module Resque
    describe Resource do
      before do
        @article = Factory(:article, :author => Factory(:user))
        @resource = Resource.new(@article)
      end
  
      it "deserializing from JSON returns original article" do
        JSON.parse(@resource.to_json).should == @article
      end
    end
  end
end