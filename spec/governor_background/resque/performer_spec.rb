require 'spec_helper'

module GovernorBackground
  module Resque
    describe Performer do
      before do
        ResqueSpec.reset!
        @article = Factory(:article, :author => Factory(:user))
      end
  
      it "adds article.post to the :governor queue" do
        ::Resque.enqueue(Performer, :articles, @article.id, :post)
        Performer.should have_queued(:articles, @article.id, :post).in(:governor)
      end
      
      it "accepts any number of arguments" do
        ::Resque.enqueue(Performer, :articles, @article.id, :post, 1, 2, 3)
        Performer.should have_queued(:articles, @article.id, :post, 1, 2, 3).in(:governor)
      end
    end
  end
end