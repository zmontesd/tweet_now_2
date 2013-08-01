class User < ActiveRecord::Base
  has_many :tweets

  def tweets_stale?
    ((Time.now - self.tweets.last.created_at) / 60) > 15
  end
end
