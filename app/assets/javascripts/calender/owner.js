$(function(){
  var id = $('.project_id').data('id')
  var events = {}

  $('.day')
    .css('background', 'white')
    .data('events', 0)

  $('#submit').click(function(){
    console.log(events)
    $.post('/projects/' + id + '/events', {events: events}, function(response){
      window.location.href = '/projects/' + id
    });
  })

  $('.hours').click(function(){
    var hour = $(this)
    if($(hour).data('checked') === 0){
      $(hour)
        .data('checked', 1)
        .css('background', 'green')
    }
    else{
      $(hour)
        .data('checked', 0)
        .css('background', 'white')
    }
  })

  $('.day').click(function(){
    var day = $(this)
    var date = day.data("date-iso")

    $('#save').remove()
    $('.hours')
      .css('background', 'white')
      .data('checked', 0)

    if(date in events){
      $.each(events[date], function(i, hour){
        $('.hours#' + hour)
          .css('background', 'green')
          .data('checked', 1)
      })
    }

    var button = $('<button id="save">Save</button>')
      .addClass('btn pull-right')
      .click(function(){
        var datetimes = new Array()

        $.each( $('.hours'), function(i, value){
          if ($(value).data('checked') === 1){ datetimes.push(value.id) }
        })
        events[date] = datetimes

        $.each($('.hours'), function(i, value){
          if(datetimes.length){
            day
              .data('events', 1)
              .css('background', 'green')
          }
          else{
            day
              .data('events', 0)
              .css('background', 'white')
          }
        })

        $('#myModal').modal('hide')
      });

    $('.modal-footer').append(button)
    $('#myModal').modal()
  })
})