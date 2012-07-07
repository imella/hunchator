class AuthsController < ApplicationController

  require 'uri'
  require 'digest/sha1'

  APP_ID = 3149004

  HUNCH = {
    :authorize_url => "http://hunch.com/authorize/v1?app_id=#{APP_ID}&next=/auth/callback",
    :get_token_url => "http://api.hunch.com/api/v1/get-auth-token/"
  }

  def new
    redirect_to HUNCH[:authorize_url] 
  end

  def callback
    url = "#{HUNCH[:get_token_url]}?app_id=#{APP_ID}&auth_token_key=#{params[:auth_token_key]}"

    authorization = HunchClient.signed_get_json url

    session[:auth_token] = authorization[:auth_token]
    session[:user_id] = authorization[:user_id]
    session[:status] = authorization[:status]

  end




  

end
