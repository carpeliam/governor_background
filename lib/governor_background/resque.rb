module GovernorBackground
  class Resque
    @queue = :governor

    def self.perform(article, method)
      article.send(method)
    end
  end
end