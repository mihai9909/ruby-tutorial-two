require "test_helper"

class AccountActivationsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "account activated" do

    #get signup_path
    #assert_difference 'User.count',1 do
    #  post users_path, params: {  user:{name:"Example User",
    #                                    email:"example@example.ex",
    #                                    password: "example",
    #                                    password_confirmation: "example"} }
    #end
    #follow_redirect!
    #assert_equal 1, ActionMailer::Base.deliveries.size
    
    #user = assigns(:user)
    #assert_not user.activated?
      # Try to log in before activation.
    #log_in_as(user)
    #assert_not is_logged_in?
      # Invalid activation token
    #get edit_account_activation_path("invalid token", email: user.email)
    #assert_not is_logged_in?
      # Valid token, wrong email
    #get edit_account_activation_path(user.activation_token, email: 'wrong')
    #assert_not is_logged_in?
      # Valid activation token
    #get edit_account_activation_path(user.activation_token, email: user.email)
    #assert user.reload.activated?
    #follow_redirect!
    #assert_template 'users/show'
    #assert is_logged_in?
  end
end
