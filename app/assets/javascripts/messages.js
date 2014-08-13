$(function(){
  var user_id = gon.user_id
  
  $('.delete-messages').click(function(){
    $.ajax({
      type: "DELETE",
      url: "/users/"+user_id+"/messages",
      data: {all: true },
      success: function(response){
        console.log("sweet");
        $('.message-list').fadeOut('fast').html('');
      }
    });

  });

  //  $('.delete-message').click(function(){
  //   var that = this;

  //   $.ajax({
  //     type: "DELETE",
  //     url: "/users/"+user_id+"/messages",
  //     success: function(response){
  //       console.log("sweet");
  //       // find message holding div
  //       $(that).fadeOut('fast', function(){
  //         $(that).remove();
  //       })
  //     }
  //   });

  // });

});