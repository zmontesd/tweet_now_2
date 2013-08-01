get '/' do
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  p @access_token = request_token.get_access_token(oauth_verifier: params[:oauth_verifier])

  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)

  # at this point in the code is where you'll need to create your user account and store the access token
  @user = User.find_or_create_by_username(@access_token.params[:screen_name])
  @user.oauth_token = @access_token.params[:oauth_token]
  @user.oauth_secret = @access_token.params[:oauth_token_secret]
  @user.save!

  session[:user] = @user.id

  erb :index
end

get '/tweet' do
  erb :tweet
end

post '/tweet' do
  @tweet = Tweet.create(content: params[:content], user_id: session[:user])
  TweetWorker.perform(@tweet)
  # create the tweet!
  # call TweetWorker.perform(tweet_id)
  # move the twitter.update to background worker!
  redirect '/'
end