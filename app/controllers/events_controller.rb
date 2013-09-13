class EventsController < ApplicationController
  load_and_authorize_resource :project

  def index
    @events = @project.get_events
    if request.xhr?
      render json: @events.to_json(methods: :attendance)
    else
      render :index
    end
  end

  def new
    if current_user == @project.owner && @project.funded?
      @event = Event.new
      render :new
    else
      flash[:notice] = "You aren't supposed to be here."
      redirect_to root_url
    end
  end

  def create
    if current_user == @project.owner && @project.funded?
      @project.update_events(params[:events])
      render text: "Hi"
    else
      flash[:notice] == "You can't do this."
      redirect_to root_url
    end
  end
end
