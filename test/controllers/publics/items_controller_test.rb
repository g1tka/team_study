require "test_helper"

class Publics::ItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get publics_items_index_url
    assert_response :success
  end

  test "should get show" do
    get publics_items_show_url
    assert_response :success
  end
end
