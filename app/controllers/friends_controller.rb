class FriendsController < ApplicationController
  

  def index
    url = "http://api.hunch.com/api/v1/get-friends?auth_token=#{session[:auth_token]}&limit=#{params[:limit]}&offset=#{params[:offset]}"
    @friends = HunchClient.get_json url
  end

  def recommend
    friend_id = params[:id]
    url = "http://api.hunch.com/api/v1/get-recommendations?auth_token=#{session[:auth_token]}&friend_id=#{friend_id}&topic_ids=cat_gifts&limit=20"
    @recommendations = HunchClient.get_json url

  end

end
