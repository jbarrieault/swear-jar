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
      }
    });

  });


});