class FriendsController < ApplicationController
  

  def index
    url = "http://api.hunch.com/api/v1/get-friends?auth_token=#{session[:auth_token]}&limit=#{params[:limit]}&offset=#{params[:offset]}"
    @friends = HunchClient.get_json url
  end

  def recommend
    @friend_id = params[:id]
    # session[@friend_id] = nil

    if session[@friend_id].nil?
      session[@friend_id] = {}
    end

    if session[@friend_id][:blocked_ids].nil?
      session[@friend_id][:blocked_ids] = []
    end

    if session[@friend_id][:likes].nil?
      session[@friend_id][:likes] = []
    end

    if session[@friend_id][:dislikes].nil?
      session[@friend_id][:dislikes] = []
    end

    if session[@friend_id][:offset].nil?
      session[@friend_id][:offset] = 0
    end 

    # raise "#{session[:blocked_ids]}"
    results_string = session[@friend_id][:blocked_ids].join(',')
    likes_string = session[@friend_id][:likes].join(',')
    dislikes_string = session[@friend_id][:dislikes].join(',')
      respond_to do |format|
      format.html do
        url = "http://api.hunch.com/api/v1/get-recommendations?auth_token=#{session[:auth_token]}&friend_id=#{@friend_id}&topic_ids=all_394864&limit=3&offset=#{session[@friend_id][:offset]}&dislikes=#{dislikes_string}&likes=#{likes_string}&exclude_dislikes=1"
        @recommendations = HunchClient.get_json url
        @recommendations[:recommendations].delete_if { |r| session[@friend_id][:blocked_ids].include? r['result_id'] }
      end
      format.json do
        session[@friend_id][:offset] += 3
        results_blocked = (params[:blocked].split(',') + results_string.split(',')).join(',')
        results_likes = (params[:likes].split(',') + likes_string.split(',')).join(',')
        results_dislikes = (params[:dislikes].split(',') + dislikes_string.split(',')).join(',')
        url = "http://api.hunch.com/api/v1/get-recommendations?auth_token=#{session[:auth_token]}&friend_id=#{@friend_id}&topic_ids=all_394864&limit=3&offset=#{session[@friend_id][:offset]}&dislikes=#{results_dislikes}&likes=#{results_likes}&exclude_dislikes=1"
        @recommendations = HunchClient.get_json url
        
        session[@friend_id][:blocked_ids] += results_blocked.split(',')
        session[@friend_id][:likes] += results_likes.split(',')
        session[@friend_id][:dislikes] += results_dislikes.split(',')

        @recommendations[:recommendations].delete_if { |r| session[@friend_id][:blocked_ids].include? r['result_id'] }

        render json: @recommendations.to_json
      end
    end
  end

end
