class ApplicationController < ActionController::Base
  def hello
    render html: "Prostii citesc"
  end
  def goodbye
    render html: "Goodbye, world!"
  end
  
  skip_forgery_protection
end
