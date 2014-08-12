$(function(){
  $('.scan').click(function(){

    $.ajax({
      type: "GET",
      url: "/scan",
      success: function(response){
        console.log(response);
        console.log("nice!");

      },
      error: function(response){
        console.log(response);
        console.log("uh oh");
        //seems to error, but status is 200 OK
        // and it does work.
      }
    });

  });


});