require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:mihaitza)
  end

  test "unsuccessful edit" do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: {name: "",password: "foo",password_confirmation: "bar"} }
    assert_template 'users/edit'
    assert_select 'div.alert', 'The form contains 3 errors.'
  end

  test "successful edit" do
    log_in_as @user
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {user: {name: "Mihai",
    password: "",
    password_confirmation: ""}}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal "Mihai", @user.name
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name = "Foo Bar"
    patch user_path(@user), params: { user: { name: name,
    password: "",
    password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_not session[:forwarding_url] #checks for friendly forwarding
  end


end
