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