require 'test_helper'

class AuthenticationsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
	setup do
		@request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in users(:mum)
		@authentication = authentications(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:authentications)
  end


  test "should destroy authentication" do
    assert_difference('Authentication.count', -1) do
      delete :destroy, id: @authentication
    end

    assert_redirected_to authentications_path
  end
end
