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

Day.prototype.set_valid = function(valid){
  if(valid != null){
    $.each(this.hours, function(i, hour){
      this.valid = valid
      hour.set_valid()
    })
  }
  else{
    var valid_hours = 0
    $.each(this.hours, function(i, hour){
      if(hour.valid > valid_hours){
        valid_hours = hour.valid
      }
    })
    this.valid = valid_hours
  }
}

Day.prototype.set_volunteers = function(){
  var volunteers = 0
  $.each(self.hours, function(i, hour){
    volunteers += hour.volunteers
  })
  self.volunteers = volunteers
}

Day.prototype.get_hour = function(hour){
  return this.hours[hour - 1]
}