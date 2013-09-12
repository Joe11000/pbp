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
    current_month.set_volunteer_hours()
    update_calendar()
    $('#myModal').modal('hide')
  })

  $('#submit').click(function(){
    var events = []
    $.each(months, function(i, month){
      $.each(month.dates, function(i, day){
        var hours = []
        $.each(day.hours, function(i, hour){
          if(hour.valid == 2){
            hours.push(hour.hour + 1)
          }
        })
        if(hours.length){
          events.push({date: day.date, hours: hours})
        }
      })
    })
    $.post('/projects/' + id + '/events/', {events: events}, function(response){

    })
  })
})

function populate_events(){
  $.get('/projects/' + id + '/events/', function(response){
    $.each(response, function(i, event){
      create_event(event)
    })
    $.each(months, function(i, month){
      month.set_valid()
      month.set_volunteer_hours()
    })
    validate_all()
    update_calendar()
  }, 'json')
}

function create_event(event){
  hour = get_day(event.date).get_hour(event.hour)
  hour.set_valid(2)
  hour.set_event_id(event.id)
  hour.add_volunteers(event.attendance)
}

function update_calendar(){
  reset('day')
  $.each(current_month.dates, function(i, day){
    var color = {2: "green", 1: "white", 0: "white"}
    $('[data-date-iso="' + day.date + '"]').css('background', color[day.valid])
    if(day.valid > 0 && day.volunteer_hours > 0){
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
    if(hour.valid > 0 && hour.volunteers > 0){
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

function validate_all(){
  $.each(months, function(i, month){
    $.each(month.dates, function(i, day){
      $.each(day.hours, function(i, hour){
        if(hour.valid === 0){
          hour.set_valid(1)
        }
      })
      if(day.valid != 2){
        day.set_valid(1)
      }
    })
  })
}