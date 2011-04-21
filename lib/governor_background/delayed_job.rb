module GovernorBackground
  class DelayedJob < Struct.new(:article, :method)
    def perform
      article.send(method)
    end
  end
end