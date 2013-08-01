class User < ActiveRecord::Base
  has_many :tweets

  def tweet(status)
    tweet = tweets.create!(:status => status)
    TweetWorker.perform_async(tweet.id)
  end

  def tweets_stale?
    ((Time.now - self.tweets.last.created_at) / 60) > 15
  end
end
