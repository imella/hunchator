class FriendsController < ApplicationController
  

  def index
    url = "http://api.hunch.com/api/v1/get-friends?auth_token=#{session[:auth_token]}&limit=#{params[:limit]}&offset=#{params[:offset]}"
    @friends = HunchClient.get_json url
  end

  def recommend
    @friend_id = params[:id]
    # session[:blocked_ids] = nil
    if session[:blocked_ids].nil?
      session[:blocked_ids] = []
    end
    # raise "#{session[:blocked_ids]}"
    results_string = session[:blocked_ids].join(',')
      respond_to do |format|
      format.html do
        url = "http://api.hunch.com/api/v1/get-recommendations?auth_token=#{session[:auth_token]}&friend_id=#{@friend_id}&topic_ids=all_394864&limit=3&dislikes=#{params[:dislikes]}&exclude_dislikes=1&blocked_result_ids=#{results_string}"
        @recommendations = HunchClient.get_json url
      end
      format.json do 
        results_blocked = (params[:blocked].split(',') + results_string.split(',')).join(',')
        url = "http://api.hunch.com/api/v1/get-recommendations?auth_token=#{session[:auth_token]}&friend_id=#{@friend_id}&topic_ids=all_394864&limit=3&dislikes=#{params[:dislikes]}&exclude_dislikes=1&blocked_result_ids=#{results_blocked}"
        @recommendations = HunchClient.get_json url
    
        
        session[:blocked_ids] += results_blocked.split(',')

        render json: @recommendations.to_json
      end
    end
  end

end
