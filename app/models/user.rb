class User < ActiveRecord::Base
	before_save { self.email.downcase! }

	validates :name, presence: true, length: { maximum: 50 }
	validates :email, presence: true, length: { maximum: 255 },
				format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i },
				uniqueness: {case_sensitive: false}
	validates :password, length: {minimum: 6 }

	has_secure_password
end
