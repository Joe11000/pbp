namespace :schedule_job do
  desc "grabs all projects ending today and charges them"
  task :project_charge => :environment do
    Project.charge_ending_projects
  end
end
