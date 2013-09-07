require 'balanced'

Balanced.configure(ENV['BALANCED_SECRET'])

namespace :schedule_job do
  desc "grabs all projects ending today and charges them"
  task :project_charge => :environment do
    Project.find_all_by_deadline(DateTime.now.midnight).each do |project|
      donation = project.get_donations.last
      customer = Balanced::Customer.new.save
      p response = customer.add_card(donation[:token])
      p final = response.debit(amount: donation[:amount])
    end
  end
end
