var months = []
var current_month = null
var current_day = null
var id = null

$(function(){
  $('table').removeClass('table-striped')

  current_month = get_month($('tbody').data('month'), $('tbody').data('year'))

  id = $('.project_id').data('id')

  populate_events()

  $('.day').click(function(){
    day = get_day($(this).data('date-iso'))
    if(day.valid){
      current_day = day
      update_day(current_day)
      $('#myModal').modal()
    }
  })

  $('.hours').click(function(){
    hour = current_day.get_hour(parseInt(this.id) + 1)
    toggle = {1: 2, 2: 1, 0: 0}
    hour.set_valid(toggle[hour.valid])
    hour.toggle_volunteers(toggle[hour.valid])
    update_day(current_day)
  })

  $('#save').click(function(){
    current_month.set_valid()
    current_month.set_volunteer_hours()
    update_calendar()
    $('#myModal').modal('hide')
  })

  $('#submit').click(function(){
    var event_ids = []
    $.each(months, function(i, month){
      $.each(month.dates, function(i, day){
        $.each(day.hours, function(i, hour){
          if(hour.valid == 2){
            event_ids.push(hour.event_id)
          }
        })
      })
    })
    $.post('/projects/' + id + '/commitments', {event_ids: event_ids})
  })
})

function populate_events(){
  $.get('/projects/' + id + '/events/', function(events){
    $.get('/projects/' + id + '/commitments', function(event_ids){
      $.each(events, function(i, event){
        if($.inArray(event.id, event_ids) >= 0){
          create_event(event, 2)
        }
        else{
          create_event(event, 1)
        }
      })
      $.each(months, function(i, month){
        month.set_valid()
        month.set_volunteer_hours()
      })
      update_calendar()
    })
  }, 'json')
}

function create_event(event, valid){
  hour = get_day(event.date).get_hour(event.hour)
  hour.set_valid(valid)
  hour.set_event_id(event.id)
  hour.add_volunteers(event.attendance)
}

function update_calendar(){
  reset('day')
  $.each(current_month.dates, function(i, day){
    var color = {2: "green", 1: "yellow", 0: "white"}
    $('[data-date-iso="' + day.date + '"]').css('background', color[day.valid])
    if(day.valid != 0){
      var tag = $('<h1></h1>')
        .addClass('volunteer')
        .append(day.volunteer_hours)
        .css('position', 'relative')
        .css('left', '40%')
      $('[data-date-iso="' + day.date + '"]').append(tag)
    }
  })
}

function update_day(day){
  reset('hours')
  $.each(day.hours, function(i, hour){
    var color = {2: "green", 1: "white"}

    $('#' + hour.hour).css('background', color[hour.valid])
    if(hour.valid != 0){
      var tag = $('<a></a>')
        .addClass('volunteer')
        .append(hour.volunteers)
        .css('text-align', 'center')
      $('#' + hour.hour).append(tag)
    }
  })
}

function reset(selector){
  $('.' + selector).css('background', 'grey')
  $('.volunteer').remove()
}
