class UsersController < ApplicationController
	include ActionController::Live

  def events
    response.headers["Content-Type"] = "text/event-stream"
    redis = Redis.new
    redis.subscribe("channel_#{current_user.id}") do |on|
    	on.message do |event, count|
	      response.stream.write "data: #{count}\n\n"
	    end
	  end
      sleep 0.1
  ensure
    response.stream.close
  end
  
  def index
        
  end

  def show
  	@posts = Post.where(user_id: current_user.id)
  end

end