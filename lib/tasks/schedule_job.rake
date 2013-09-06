require 'active_support/all'

namespace :schedule_job do
  desc "grabs all projects ending today and charges them"
  task :project_charge => :environment do
    p Project.find_all_by_deadline(DateTime.now.midnight)
  end
end
