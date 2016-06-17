class User < ActiveRecord::Base

	def self.get_image(user)
		facebook = Koala::Facebook::API.new(user.oauth_token)
		facebook.get_object("me?fields=picture")
		# binding.pry
	end
  # def self.koala(auth)
  #   access_token = auth['token']
  #   facebook = Koala::Facebook::API.new(access_token)
  #   facebook.get_object("me?fields=name,picture")
  # end

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

end