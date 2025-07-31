require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get dashboard_url
    assert_response :success
    assert_select "title", "Dashboard | Eureka Caffe"
  end
end
