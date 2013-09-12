var months = []
var current_month = null
var current_day = null
var id = null

$(function(){
  $('table').removeClass('table-striped')

  id = $('.project_id').data('id')

  current_month = get_month($('tbody').data('month'), $('tbody').data('year'))

  populate_events()

  $('.day').click(function(){
    day = get_day($(this).data('date-iso'))
    if(day.valid){
      current_day = day
      update_day(day)
      $('#myModal').modal()
    }
  })

  $('.hours').click(function(){
    hour = current_day.get_hour(parseInt(this.id) + 1)
    toggle = {1: 2, 2: 1}
    hour.set_valid(toggle[hour.valid])
    update_day(current_day)
  })

  $('#save').click(function(){
    current_month.set_valid()
    update_calendar()
    $('#myModal').modal('hide')
  })

  $('#submit').click(function(){
    var event_ids = new Array()

    $.post('/projects/' + id + '/commitments/', {event_ids: event_ids}, function(response){
    })
  })
})

function populate_events(){
  $.get('/projects/' + id + '/events/', function(response){
    $.each(months, function(i, month){
      month.set_valid(1)
    })
    $.each(response, function(i, event){
      create_event(event)
    })
    current_month.set_valid()
    update_calendar()
  }, 'json')
}

function create_event(event){
  get_day(event.date).get_hour(event.hour).set_valid(2)
}

function update_calendar(){
  reset('day')
  $.each(current_month.dates, function(i, day){
    var color = {2: "green", 1: "white", 0: "white"}
    $('[data-date-iso="' + day.date + '"]').css('background', color[day.valid])
  })
}

function update_day(day){
  reset('hours')
  $.each(day.hours, function(i, hour){
    var color = {2: "green", 1: "white"}
    $('#' + hour.hour).css('background', color[hour.valid])
  })
}

function reset(selector){
  $('.' + selector).css('background', 'grey')
}