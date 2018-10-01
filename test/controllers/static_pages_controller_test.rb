require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  # def setup
  #   @base_title = "Ruby on Rails Tutorial Sample App"
  # end

  test "should get home" do
    get root_path
    assert_response :success
    # assert_select "title", "Home | #{@base_title}"
    assert_select "title", "Home"
  end

  test "should get help" do
    get help_path
    assert_response :success
    # assert_select "title", "Help | #{@base_title}"
    assert_select "title", "Help"
  end

  test "should get about" do
    get about_path
    assert_response :success
    # assert_select "title", "About | #{@base_title}"
    assert_select "title", "About"
  end

  test "should get contact" do
    get contact_path
    assert_response :success
    # assert_select "title", "Contact | #{@base_title}"
    assert_select "title", "Contact"
  end

end
