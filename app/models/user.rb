class User < ActiveRecord::Base
	attr_accessor :remember_token, :activation_token, :reset_token
    has_many :microposts, dependent: :destroy
    has_many :active_relationship, class_name: "Relationship",
                                   foreign_key: "follower_id",
                                   dependent: :destroy
    has_many :following, through: :active_relationship, source: "followed"
    has_many :passive_relationship, class_name: "Relationship",
                                    foreign_key: "followed_id",
                                    dependent: :destroy
    has_many :followers, through: :passive_relationship, source: "follower"
	before_save :email_downcase
    before_create :create_activation_digest

	validates :name, presence: true, length: { maximum: 50 }
	validates :email, presence: true, length: { maximum: 255 },
				format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i },
				uniqueness: {case_sensitive: false}
	validates :password, length: {minimum: 6 }, allow_blank: true

	has_secure_password

	def self.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                             BCrypt::Engine.cost

        BCrypt::Password.create(string, cost: cost)
    end

    def self.new_token
    	SecureRandom.urlsafe_base64
    end

    def remember
    	self.remember_token = User.new_token
    	update_attribute(:remember_digest, User.digest(remember_token))
    end

    def authenticated?(attribute, token)
        digest = self.send("#{attribute}_digest")
    	return false if digest.nil?
    	BCrypt::Password.new(digest) == token
    end

    def forget
    	update_attribute(:remember_digest, nil)
    end

    #Activates an account
    def activate
        update_columns(activated: true, activated_at: Time.zone.now)
    end

    #Sends activation mail
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end

    def create_reset_digest
        self.reset_token = User.new_token
        update_columns(reset_digest: User.digest(reset_token),
                       reset_sent_at: Time.zone.now)
    end

    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end

    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end

    def feed
        Micropost.where("user_id = ?", id)
    end

    #Follows user
    def follow(other_user)
        active_relationship.create(followed_id: other_user.id)
    end

    #Unfollows user
    def unfollow(other_user)
        active_relationship.find_by(followed_id: other_user.id).destroy
    end

    #Returns true if the current user following the other user
    def following?(other_user)
        following.include?(other_user)
    end





    private

    def email_downcase
        self.email = email.downcase
    end

    def create_activation_digest
        self.activation_token = User.new_token
        self.activation_digest = User.digest(activation_token)
    end
end
