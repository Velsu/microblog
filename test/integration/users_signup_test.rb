require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

	test "User.count" do
		get signup_path
		before_count = User.count 
		post users_path, user: { name: "   ",
						email: "foobar@com.pl",
						password: "bar",
						password_confirmation: "domingo" }
		after_count = User.count
		assert_equal before_count, after_count
		assert_template 'users/new'
	end


end
