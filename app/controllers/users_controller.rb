class UsersController < ApplicationController

  def index

  end

  def login
    # @user = User.koala(request.env['omniauth.auth']['credentials'])
  end

  def show
  	# @user_image = User.get_image(current_user)
  	@user_post = User.get_posts(current_user)
  	# binding.pry
  end

end