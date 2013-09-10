class EventsController < ApplicationController
  def show
    @events = Project.find(params[:project_id]).events
  end

  def create

  end

  def new

  end
end
