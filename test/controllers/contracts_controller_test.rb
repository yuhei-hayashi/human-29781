require 'test_helper'

class ContractsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get contracts_new_url
    assert_response :success
  end

end
