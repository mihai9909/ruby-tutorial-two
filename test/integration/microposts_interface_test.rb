require "test_helper"

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:mihaitza)
    @no_posts_user = users(:malory)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select 'div#error_explanation'
    assert_select 'a[href=?]', '/home?page=2' # Correct pagination link
    # Valid submission
    content = "This micropost really ties the room together"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # Delete post
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # Visit different user (no delete links)
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end

  test "user should be unable to see feed when if he hasn't posted" do 
    log_in_as(@no_posts_user)
    get root_path
    assert_select 'div.alert', 'You haven\'t made a post in 24 hours. Make a post to see what your followed users are up to.'
     # Valid submission
     content = "Valid post"
     assert_difference 'Micropost.count', 1 do
       post microposts_path, params: { micropost: { content: content } }
     end
     assert_redirected_to root_url
     follow_redirect!
     assert_select 'div.alert.alert-info', count: 0
  end
    
end