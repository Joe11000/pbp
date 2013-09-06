require 'active_support/all'
require 'balanced'

namespace :schedule_job do
  desc "grabs all projects ending today and charges them"
  task :project_charge => :environment do
    Balanced.configure(ENV['BALANCED_SECRET'])
    customer = Balanced::Customer.new(name: "", email: "").save
    Project.find_all_by_deadline(DateTime.now.midnight).each do |project|
    end
  end
end
