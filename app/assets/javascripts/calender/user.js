var months = []
var current_month = null
var current_day = null

$(function(){

  $('table').removeClass('table-striped')

  var id = $('.project_id').data('id')

  current_month = get_month($('tbody').data('month'), $('tbody').data('year'))

  populate_events(id)

  $('.hours').click(function(){
    console.log(this.id)
    console.log(current_day.get_hour(this.id + 1))
    update_day(current_day)
  })

  $('.day').click(function(){
    var square = $(this)
    day = get_day(square.data('date-iso'))
    if(day.valid){
      current_day = day
      update_day(day)
      $('#myModal').modal()
    }
  })

  // $('#save').click(function(){
  //   var commit = new Array()
  //   $.each( $('.hours'), function(i, value){
  //     if($(value).data('checked') === 1){
  //       commit.push($(value).data('value'))
  //     }
  //   })
  //   var date = $('.modal-body').data('date')
  //   commitments[date] = commit
  //   paint_calendar()
  //   $('#myModal').modal('hide')
  // })

  // $('#submit').click(function(){
  //   var event_ids = new Array()
  //   $.each(commitments, function(i, day){
  //     $.each(day, function(i, event){
  //       event_ids.push(event.id)
  //     })
  //   })
  //   $.post('/projects/' + id + '/commitments/', {event_ids: event_ids}, function(response){
  //   })
  // })
})

function update_day(day){
  reset_day()
  $.each(day.hours, function(i, hour){
    var square = $('#' + hour.hour)
    if (hour.valid == 1){
      square.css('background', 'white')
    }
    else if (hour.valid == 2){
      square.css('background', 'green')
    }
  })
}

function update_calendar(){
  reset_calendar()
  $.each(current_month.dates, function(i, day){
    var square = $('[data-date-iso="' + day.date + '"]')
    if (day.valid == 1){
      square.css("background", "yellow")
    }
    else if (day.valid == 2){

    }
    else{
      square.css("background", "white")
    }
  })
}

function reset_calendar(){
  $('.day').css('background', 'grey')
}

function reset_day(){
  $('.hours').css('background', 'grey')
}

function populate_events(id){
  $.get('/projects/' + id + '/events/', function(response){
    $.each(response, function(i, event){
      create_event(event)
    })
    $.each(months, function(i, month){
      month.set_valid()
    })
    update_calendar()
  }, 'json')
}

function create_event(event){
  get_day(event.date).get_hour(event.hour).set_valid(1)
}

function get_month(num, year){
  var this_month = null
  $.each(months, function(i, month){
    if(month.get_num() === num && month.get_year() === year){
      this_month = month
    }
  })
  if(this_month){
    return this_month
  }
  else{
    console.log("ELSE")
    this_month = new Month(num, year)
    months.push(this_month)
    return this_month
  }
}

function get_day(date){
  var day = new Date(date + 'Z-0500')
  return get_month(day.getMonth() + 1, day.getFullYear()).get_day(day.getDate())
}

function Month(num, year){
  this.num = num
  this.year = year
  this.valid = 0
  this.dates = []

  this.add_days()
}

Month.prototype.add_days = function(){
  month = this
  $.each($('.day'), function(i, day){
    if(!$(day).hasClass('not-current-month')){
      month.dates[i] = new Day($(day).data('date-iso'))
    }
  })
}

Month.prototype.get_year = function(){
  return this.year
}

Month.prototype.get_num = function(){
  return this.num
}

Month.prototype.get_day = function(day){
  return this.dates[day - 1]
}

Month.prototype.set_valid = function(valid){
  if(valid != null){
    $.each(this.dates, function(i, date){
      date.set_valid(valid)
    })
  }
  else{
    $.each(this.dates, function(i, date){
      date.set_valid()
      if(date.valid){
        month.valid = 1
      }
    })
  }
}

function Day(date){
  this.date = date
  this.valid = 0
  this.hours = new Array()
  this.volunteers = 0

  this.add_hours()
}

Day.prototype.add_hours = function(){
  for(var i = 0; i < 24; i++){
    this.hours[i] = new Hour(i)
  }
}

Day.prototype.get_hour = function(hour){
  return this.hours[hour - 1]
}

Day.prototype.set_valid = function(valid){
  console.log("CALLED")
  if(valid != null){
    this.valid = valid
  }
  else{
    var valid_hours = 0

    $.each(this.hours, function(i, hour){
      valid_hours += hour.valid
    })

    if(valid_hours){
      this.valid = 1
    }
    else{
      this.valid = 0
    }
  }
}

Day.prototype.set_volunteers = function(){
  var volunteers = 0
  $.each(self.hours, function(i, hour){
    volunteers += hour.volunteers
  })
  self.volunteers = volunteers
}

function Hour(hour){
  this.hour = hour
  this.valid = 0
  this.volunteers = 0
}

Hour.prototype.add_volunteers = function(volunteers){
  self.volunteers = volunteers
}

Hour.prototype.set_valid = function(valid){
  this.valid = valid
}
