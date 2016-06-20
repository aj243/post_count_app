class User < ActiveRecord::Base

	has_many :posts
	after_create :fetch_all_data

	def self.get_image(user)
		facebook = Koala::Facebook::API.new(user.oauth_token)
		facebook.get_object("me?fields=picture")
	end

	def self.get_posts(user)
		facebook = Koala::Facebook::API.new(user.oauth_token)
		facebook.get_object("me?fields=posts.until(01/01/2015).since(01/03/2014)")
	end

  def self.from_omniauth(auth)
	  where(auth.slice(provider: auth.provider, uid: auth.uid)).first_or_initialize.tap do |user|
	    user.provider = auth.provider
	    user.uid = auth.uid
	    user.name = auth.info.name
	    user.oauth_token = auth.credentials.token
	    user.oauth_expires_at = Time.at(auth.credentials.expires_at)
	    user.save
	  end
	end

	private

	def fetch_all_data
		FacebookWorker.perform_async(self.id)
	end

end