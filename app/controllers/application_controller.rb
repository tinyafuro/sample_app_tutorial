class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def hello
    return html: "hello,world!"
  end
  
end
