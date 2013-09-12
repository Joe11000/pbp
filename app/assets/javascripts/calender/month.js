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

Month.prototype.set_valid = function(valid){
  if(valid != null){
    $.each(this.dates, function(i, date){
      this.valid = valid
      date.set_valid(valid)
    })
  }
  else{
    var valid_dates = 0
    $.each(this.dates, function(i, date){
      date.set_valid()
      if(date.valid > valid_dates){
        valid_dates = date.valid
      }
    })
    this.valid = valid_dates
  }
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
    this_month = new Month(num, year)
    months.push(this_month)
    return this_month
  }
}

function get_day(date){
  var day = new Date(date + 'Z-0500')
  return get_month(day.getMonth() + 1, day.getFullYear()).get_day(day.getDate())
}