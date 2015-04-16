require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

	test "Should be unable to sign up" do
		get signup_path
		assert_no_difference "User.count" do
			post users_path, user: { name: "   ",
						email: "foobar@com.pl",
						password: "bar",
						password_confirmation: "domingo" }
	end

	assert_template 'users/new'
end


test "Should be able to sign up" do
		get signup_path
		assert_difference "User.count", 1 do
			post_via_redirect users_path, user: { name: "Josh",
						email: "foobar@com.pl",
						password: "domingo",
						password_confirmation: "domingo" }
	end

	assert_template 'users/show'
end







end
