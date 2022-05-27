class ApplicationController < ActionController::Base
  def hello
    render 'layouts/home'
  end

  def goodbye
    render html: "Goodbye, world!"
  end

  skip_forgery_protection
end
