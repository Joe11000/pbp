class Event < ActiveRecord::Base
  belongs_to :project
  has_many :user_availabilities, dependent: :destroy
  has_many :users, through: :user_availabilities
 
  attr_accessible :start_time, :project_id

  def month_day
    self.start_time.day
  end

  def bookVolunteer
    params[:event_id].values.each do |event_id|
      current_user.user_availabilities.create(event_id: event_id)
    end

    redirect_to project_event_url(params[:project_id])
  end
end
