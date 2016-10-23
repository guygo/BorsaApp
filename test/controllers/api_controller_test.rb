require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "should get ShareByName" do
    get :ShareByName
    assert_response :success
  end

end
