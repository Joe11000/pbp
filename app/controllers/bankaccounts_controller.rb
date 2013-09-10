class BankaccountsController < ApplicationController
  def show
  end

  def create
    if params["error"]
      error_array = []

      params["error"].each_value do |value|
        error_array << value.to_s
      end

      flash[:notice] = error_array

      Rails.logger.debug "We had an error while trying to add a bank account for the user"

      render :json => {redirect_to: user_bankaccounts_url(params["user_id"].to_i)}
    else
      bank_account_token = params["data"]["uri"]

      current_user.set_bankaccount_token(bank_account_token)

      current_user.save

      Rails.logger.debug "Everything is great when adding the bank account, let's rock"

      flash[:bank_success] = "Thank you for adding your bank account! Good luck with the project!"
      render :json => {redirect_to: user_url(params["user_id"].to_i)}
    end
  end
end
