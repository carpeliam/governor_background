require 'spec_helper'
require File.expand_path('../../../../lib/governor_background/resque/performer_with_state',  __FILE__)

module GovernorBackground
  module Resque
    describe PerformerWithState do
      before do
        ResqueSpec.reset!
        @article = Factory(:article, :author => Factory(:user))
        @id = PerformerWithState.create(:resource => :articles, :id => @article.id, :method => :post)
      end
  
      it "adds article.post to the :governor queue" do
        PerformerWithState.should have_queued(@id, {:resource => :articles, :id => @article.id, :method => :post}).in(:governor)
      end
    end
  end
end