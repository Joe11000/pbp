class EventsController < ApplicationController
  def index
      @project = Project.find(params[:project_id]) 
      @events = @project.events
    if request.xhr?
      @events = @project.get_events_for_day(params[:date])
      render json: @events
    else
      render :index
    end
  end

  def new
    @project = Project.find(params[:project_id])
  end

  def create
    @project = Project.find(params[:project_id])
    params[:events].each do |day|
      day[1].each do |hour|
        @project.events.create(date: Date.parse(day[0]), hour: hour)
      end
    end
    render text: "Hi"
  end
end
