class CalendarApplication < ApplicationController
  def show
    @event_calendar = EventCalendar.new(2012, 10) do |c|
      c.id = 'calendar'
      c.events = Event.all
    end
  end
end
