require 'balanced'

Balanced.configure(ENV["BALANCED_SECRET"])

class Donation < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates_presence_of :user, :project
  validates_numericality_of :hours, :dollar_amount, greater_than_or_equal_to: 0

  attr_accessible :user, :project, :hours, :dollar_amount

  def debit_amount
    customer = Balanced::Customer.find(self.user.balanced_customer_uri)
    response = customer.debit(:amount => self.dollar_amount.to_i)
    true if response.attributes["status"] == "succeeded"
  end
end
