class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]
def index
@tweets = Tweet.all
end
def show
end
def new
if !session[:user]
redirect_to tweets_path, :alert => "You have to log in to create a new tweet"   
else
@tweet = Tweet.new
end
end
def edit
@tweet = Tweet.find(params[:id])
if @tweet.user.name != session[:user]
redirect_to tweets_path, :alert => "You cannot edit another user’s tweet!"   
else
@tweet = Tweet.find(params[:id])   
end
end
def create
@tweet = Tweet.new(tweet_params)
@tweet.user = User.find_by name: session[:user]
respond_to do |format|
if @tweet.save
format.html {
redirect_to tweets_url, notice: 'Tweet was successfully created.' }
format.json { render action: 'show', status: :created, location: @tweet }
else
format.html { render action: 'new' }
format.json { render json: @tweet.errors, status: :unprocessable_entity }
end
end
end

def update
respond_to do |format|
if @tweet.update(tweet_params)
format.html { redirect_to tweets_path, notice: 'Tweet was successfully updated.' }
format.json { head :no_content 
}
else
format.html { render action: 'edit' }
format.json { render json: @tweet.errors, status: :unprocessable_entity }
end
end
end
def destroy
if @tweet.user != session[:user]
redirect_to tweets_path, :alert => "You cannot delete another user’s tweet!"   
else
@tweet.destroy
respond_to do |format|
format.html { redirect_to tweets_url }
format.json { head :no_content }
end
end
end
private
# Use callbacks to share common setup or constraints between actions.
def set_tweet
@tweet = Tweet.find(params[:id])
end
# Never trust parameters from the scary internet, only allow the white list through.
def tweet_params
params.require(:tweet).permit(:text, :user_id)
end
end
