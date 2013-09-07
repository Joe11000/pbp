class ApplicationController < ActionController::Base
  protect_from_forgery
  include ApplicationHelper

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url
  end
end
