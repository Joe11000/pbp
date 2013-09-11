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

  def create
    @project = Project.find(2)
    @date = DateTime.now

    params[:hour].values.each do |hour|
      string = @date.year.to_s + " " + @date.month.to_s + " " + @date.day.to_s + " " + hour
      temp_date = DateTime.new
      puts temp_date
      @project.events.create(start_time: temp_date)
    end
  end

  def new

  end
end
