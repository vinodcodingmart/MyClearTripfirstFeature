require 'test_helper'

class InterlinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @interlink = interlinks(:one)
  end

  test "should get index" do
    get interlinks_url
    assert_response :success
  end

  test "should get new" do
    get new_interlink_url
    assert_response :success
  end

  test "should create interlink" do
    assert_difference('Interlink.count') do
      post interlinks_url, params: { interlink: { apply_count: @interlink.apply_count, keyword: @interlink.keyword, slot: @interlink.slot, url: @interlink.url } }
    end

    assert_redirected_to interlink_url(Interlink.last)
  end

  test "should show interlink" do
    get interlink_url(@interlink)
    assert_response :success
  end

  test "should get edit" do
    get edit_interlink_url(@interlink)
    assert_response :success
  end

  test "should update interlink" do
    patch interlink_url(@interlink), params: { interlink: { apply_count: @interlink.apply_count, keyword: @interlink.keyword, slot: @interlink.slot, url: @interlink.url } }
    assert_redirected_to interlink_url(@interlink)
  end

  test "should destroy interlink" do
    assert_difference('Interlink.count', -1) do
      delete interlink_url(@interlink)
    end

    assert_redirected_to interlinks_url
  end
end
