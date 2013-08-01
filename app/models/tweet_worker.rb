class TweetWorker
# < it has to know it is a redis background worker
  # require '../helpers/oauth'
  include Sidekiq::Worker

  def self.perform(tweet_id)
    tweet = Tweet.find(tweet_id)
    user  = tweet.user
    p "this is before the api call"
    
    @client = Twitter::Client.new(
      oauth_token: user.oauth_token,
      oauth_token_secret: user.oauth_secret
    )
    
    p "this is the twitter user name from the api #{@client}"

    @client.update(tweet.content)
  end
end
