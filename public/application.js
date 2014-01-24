$(document).ready(function() {

  $(document).on('click', '#player-hit input', function() {
    $.ajax({
      type: 'POST',
      url: '/game/player/hit'
    }).done(function(msg) {
       $('#game').replaceWith(msg);
    });
    return false;
  })

  $(document).on('click', '#dealer-hit input', function() {
    $.ajax({
      type: 'POST',
      url: '/game/dealer/hit'
    }).done(function(msg) {
       $('#game').replaceWith(msg);
    });
    return false;
  })

  $(document).on('click', '#player-stay input', function() {
    $.ajax({
      type: 'POST',
      url: '/game/player/stay'
    }).done(function(msg) {
       $('#game').replaceWith(msg);
    });
    return false;
  })

  $(document).on('click', '#bet-button', function() {
    $.ajax({
      type: 'POST',
      url: '/game/page/bet'
      data: {
        bet: $(this).serialize();
      }
    }).done(function(msg) {
       $('#game').replaceWith(msg);
    });
    return false;
  })

})