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
  @access_token = request_token.get_access_token(oauth_verifier: params[:oauth_verifier])
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)

  # at this point in the code is where you'll need to create your user account and store the access token
  @user = User.find_or_create_by_username(@access_token.params[:screen_name])
  @user.oauth_token = @access_token.params[:oauth_token]
  @user.oauth_secret = @access_token.params[:oauth_token_secret]
  @user.save!

  session[:user_id] = @user.id

  erb :index
end

get '/tweet' do
  erb :index
end

post '/tweet' do
  @tweet = Tweet.create(content: params[:content], user_id: session[:user])
  @job_id = TweetWorker.perform_async(@tweet.id)
  @tweet.job_id = @job_id
  @tweet.save!
  @tweet.user.to_json
  # redirect '/'
end


get '/status/:job_id' do |job_id|
  p "this is the job id #{job_id}"
  # return the status of a job to an AJAX call
end

