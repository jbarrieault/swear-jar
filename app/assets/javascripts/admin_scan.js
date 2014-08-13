$(function(){
  $('.scan').click(function(){

    $.ajax({
      type: "GET",
      url: "/scan",
      success: function(response){
        console.log(response);
        console.log("nice!");
        $flash = $('.error-holder');
        $flash.hide();
        $flash.append('<p class="notice">Tweets Scanned</p>');
        $flash.fadeIn(800, function(){
          $flash.fadeOut(800);
        });

      },
      error: function(response){
        console.log(response);
        console.log("uh oh");
      }
    });

  });


});