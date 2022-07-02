require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @admin = users(:mihaitza)
    @non_admin = users(:archer)
  end

  test "index as admin including pagination and delete links" do
    log_in_as @admin
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
  

  test "non-activated accounts should not appear on index and cannot be accessed" do
    get signup_path
    assert_difference 'User.count',1 do
      post users_path, params: {  user:{name:"Example User",
                                        email:"example@example.ex",
                                        password: "example",
                                        password_confirmation: "example"} }
    end
    follow_redirect!
    get login_path
    log_in_as @non_admin
    get users_path
    assert_select 'a', text: "Example User", count: 0
    user = User.find_by(email: "example@example.ex")
    get user_path(user)
    follow_redirect!
    assert_template root_path
    assert_select 'div.alert.alert-warning', 'User hasn\'t activated his account'
  end
end
