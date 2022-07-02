require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    ActionMailer::Base.deliveries.clear
  end
    
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
      email: "user@invalid",
      password: "foo",
      password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger'
    assert_select "li", "Name can't be blank"
    assert_select "li", "Email is invalid"
    assert_select "li", "Password confirmation doesn't match Password"
    assert_select "li", "Password is too short (minimum is 6 characters)"
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count',1 do
      post users_path, params: {  user:{name:"Example User",
                                        email:"example@example.ex",
                                        password: "example",
                                        password_confirmation: "example"} }
    end
    follow_redirect!
  end
end
