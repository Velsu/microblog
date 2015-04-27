require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase
  
  def setup
  	@micropost = microposts(:orange)
  end

  test "should redirect create when not logged in" do
  	assert_no_difference "Micropost.count" do
  		post :create, micropost: {content: "b;a;ba" }
  	end
  	assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
  	assert_no_difference "Micropost.count" do
  		delete :destroy, id: @micropost
  	end
  	assert_redirected_to login_url
  end

  test "user should not be able to delete other users posts" do
    log_in_as(users(:luke))
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: micropost
    end
    assert_redirected_to root_url
  end
end
