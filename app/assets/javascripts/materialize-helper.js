$(document).ready(function(){

  $(".button-collapse").sideNav({
    menuWidth: 175,
    edge: 'left',
    closeOnClick: true
  });

  $('.slider').slider({
    Height: 425
  });

  $(".dropdown-button").dropdown({
    inDuration: 300,
    outDuration: 225,
    constrain_width: false,
    hover: true,
    gutter: 0,
    belowOrigin: true
  });

  $('.modal-trigger').leanModal({
     dismissible: true
  });

  $( "#applied-button" ).click(function() {
    alert( "You have already applied for this job" );
  });
});
