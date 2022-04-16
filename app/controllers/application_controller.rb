class ApplicationController < ActionController::Base
  def hello
    render html: "hola, mundo!"  
  end
  def goodbye
    renger html: "Goodbye, world!"
  end
end
