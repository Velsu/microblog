require 'test_helper'

class UserTest < ActiveSupport::TestCase

	def setup
		@user = User.new(name: "Luke", email: "user@example.com",
			password: "foobar", password_confirmation: "foobar" )
	end

	test "should be valid" do
		assert @user.valid?		
	end

	test "name should be invalid" do
		@user.name = "    "
		assert_not @user.valid?
	end

	test "email should be invalid" do
		@user.email = "    "
		assert_not @user.valid?
	end

	test "name should not be too long" do
		@user.name = "a" * 51
		assert_not @user.valid?
	end

	test "email should not be too long" do
		@user.email = "a" * 244 + "@example.com"
		assert_not @user.valid?
	end

	test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "should not allow duplicate users" do
  	duplicate_user = @user.dup
  	duplicate_user.email = @user.email.upcase
  	@user.save
  	assert_not duplicate_user.valid?
  end

  test "password should not be too short" do
		@user.password = @user.password_confirmation = "a" * 5
		assert_not @user.valid?
	end

	test "password should be valid" do
		@user.password = @user.password_confirmation = "a" * 20
		assert @user.valid?
	end

	test "email address should be saved as lowercase" do
		mixed_value = "Foo@ExAMPle.CoM"
		@user.email = mixed_value
		@user.save

		assert_equal mixed_value.downcase, @user.reload.email
	end

	test "authenticated? should return fale if digest is nil" do
		assert_not @user.authenticated?(:remember, '')
	end

	test "associated microposts should be destroyed along with user" do
    @user.save
    @user.microposts.create!(content: "Lorem Ipsum")
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow users" do
  	luke = users(:luke)
  	archer = users(:archer)
  	assert_not luke.following?(archer)
  	luke.follow(archer)
  	assert luke.following?(archer)
  	assert archer.followers.include?(luke)
  	luke.unfollow(archer)
  	assert_not luke.following?(archer)
  end


  test "feed should have correct posts" do

  luke = users(:luke)
  archer = users(:archer)
  lana = users(:lana)
  #Posts from followed user
  lana.microposts.each do |post_following|
  	assert luke.feed.include?(post_following)
  end
  #Posts from self
  luke.microposts.each do |post_self|
  	assert luke.feed.include?(post_self)
  end
  #Posts from unfollowed user
  archer.microposts.each do |post_unfollowed|
  	assert_not luke.feed.include?(post_unfollowed)
  end
end



end
