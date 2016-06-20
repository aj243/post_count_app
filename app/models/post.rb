class Post < ActiveRecord::Base

	belongs_to :user

	def self.get_posts user 
		facebook = Koala::Facebook::API.new(user.oauth_token)
		user_posts = facebook.get_connections("me","posts")
	end

	def self.get_next_posts user, next_page_params
		facebook = Koala::Facebook::API.new(user.oauth_token)
		user_posts = facebook.get_page(next_page_params)
	end

	def self.update_next_posts user, time
		facebook = Koala::Facebook::API.new(user.oauth_token)
		user_posts = facebook.get_connections("me","posts",{since: time})
	end

end
