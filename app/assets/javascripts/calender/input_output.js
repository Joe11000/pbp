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
