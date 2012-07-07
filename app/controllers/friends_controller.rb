class FriendsController < ApplicationController
  
  def index
    puts "TOKEN #{session[:auth_token]}"
    url = "http://api.hunch.com/api/v1/get-friends?auth_token=#{session[:auth_token]}&limit=#{params[:limit]}&offset=#{params[:offset]}"
    @friends = HunchClient.signed_get_json url
  end

end
