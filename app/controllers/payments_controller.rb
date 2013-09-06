class PaymentsController < ApplicationController
  def show

  end

  def create
    current_user.balanced_uri = params.uri
    current_user.save
    render nothing: true
  end
end
