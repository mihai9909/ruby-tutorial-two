class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      flash.now[:info] = 'You haven\'t made a post in 24 hours. Make a post to see what your followed users are up to.' if logged_in? && current_user.activated? && !current_user.posted_today?
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end