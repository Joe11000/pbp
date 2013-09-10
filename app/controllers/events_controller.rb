class EventsController < ApplicationController
  def show
    @events = [Event.first]
  end

  def create

  end

    def new

  end
end
