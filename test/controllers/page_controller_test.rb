require "test_helper"

class PageControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get root_url
    assert_response :success
    assert_select "title", "Food | Eureka Caffe"
  end
end
