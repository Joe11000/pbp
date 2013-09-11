class UserAvailabilitiesController < ApplicationController
  def create
    success = Array.new

    params[:event_ids].each do |event_id|
      if current_user.events << Event.find(event_id)
        success << true
      else
        success << false
      end
    end

    if request.xhr?
      render text: success.inject(:&)
    else
      @project = Project.find(params[:project_id])
      @events = @project.events
      redirect_to project_events_url(@project, @events)
    end
  end
end
