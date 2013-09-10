function Hour(hour){
  this.hour = hour
  this.valid = 0
  this.volunteers = 0
  this.event_id = 0
}

Hour.prototype.set_event_id = function(event_id){
  this.event_id = event_id
}

Hour.prototype.add_volunteers = function(volunteers){
  this.volunteers = volunteers
}

Hour.prototype.toggle_volunteers = function(toggle){
  if(toggle == 2){
    this.volunteers -= 1
  }
  else{
    this.volunteers += 1
  }
}

Hour.prototype.set_valid = function(valid){
  this.valid = valid
}