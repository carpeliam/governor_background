require 'spec_helper'

module GovernorBackground
  module Resque
    describe Performer do
      before do
        ResqueSpec.reset!
        @article = Factory(:article, :author => Factory(:user))
        ::Resque.enqueue(Performer, :articles, @article.id, :post)
      end
  
      it "adds article.post to the :governor queue" do
        Performer.should have_queued(:articles, @article.id, :post).in(:governor)
      end
    end
  end
end