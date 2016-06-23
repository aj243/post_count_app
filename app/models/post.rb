class Post < ActiveRecord::Base

	belongs_to :user

	def self.get_posts id
		user = User.find_by(id)
		facebook = Koala::Facebook::API.new(user.oauth_token)
		user_posts = facebook.get_connections("me","posts")
		# binding.pry
	end

	def self.get_next_posts id, next_page_params
		user = User.find_by(id)
		facebook = Koala::Facebook::API.new(user.oauth_token)
		user_posts = facebook.get_page(next_page_params)
	end

	def self.update_next_posts id, time
		user = User.find_by(id)
		facebook = Koala::Facebook::API.new(user.oauth_token)
		user_posts = facebook.get_connections("me","posts",{since: time})
	end

end
