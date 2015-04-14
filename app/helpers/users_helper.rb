module UsersHelper

	# Gravatar helper for displaying profile pictures
	def gravatar_for(user)
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		gravatar_url = "https://secure.gravatar.com/avatars/#{gravatar_id}"
		image_tag(gravatar_url, alt: user.name, class: "gravatar" )
	end
end
