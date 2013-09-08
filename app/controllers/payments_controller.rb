class PaymentsController < ApplicationController
  def show
  end

  def create
    card_token = params["uri"]
    current_user.set_customer_token(card_token)
    current_user.save

    render nothing: true
  end
end
