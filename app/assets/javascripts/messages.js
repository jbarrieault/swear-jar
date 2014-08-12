$(function(){
  var user_id = gon.user_id
  
  $('.delete-messages').click(function(){
    $.ajax({
      type: "DELETE",
      url: "/users/"+user_id+"/messages",
      data: {message: { all: true }},
      success: function(response){
        console.log("sweet");
        $('.message-list').html('');
      }
    });

  });

});