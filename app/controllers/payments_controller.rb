class PaymentsController < ApplicationController
  def show
  end

  def create
    if params["error"]
      error_array = []

      params["error"].each_value do |value|
        error_array << value.to_s
      end

      flash[:notice] = error_array

      Rails.logger.debug "Error" # are you sure you wanted this to be merged into mater?

      render :json => {redirect_to: project_payments_url(params["project_id"].to_i)}
    else
      card_token = params["data"]["uri"]
      current_user.set_customer_token(card_token)
      current_user.save
      Rails.logger.debug "Stuff" # are you sure you wanted this to be merged into mater?
      flash[:pay_success] = "Thank you for donating!"
      render :json => {redirect_to: project_url(params["project_id"])}
    end
  end
end
