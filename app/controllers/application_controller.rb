class ApplicationController < ActionController::Base
  def hello
    render html: "Hello, world!"  
  end
  def goodbye
    render html: "Goodbye, world!"
  end
  
  skip_before_action :verify_authenticity_token
end
