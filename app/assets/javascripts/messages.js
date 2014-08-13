$(function(){
  var userId = gon.user_id
  
  $('.delete-messages').click(function(){
    $.ajax({
      type: "DELETE",
      url: "/users/"+userId+"/messages",
      data: {all: true },
      success: function(response){
        console.log("sweet");
        $('.custom-panel-content').children().fadeOut('fast');
      }
    });

  });

  $('.delete-message').click(function(e){
    e.preventDefault();
    var userId = gon.user_id
    var messageId = $(this).attr('id');
    var that = this;
    var messageContent = $(this).closest('.custom-panel-content').find('#message-'+messageId);

    $.ajax({
      type: "DELETE",
      url: "/users/"+userId+"/messages",
      data: {id: messageId},
      success: function(response){
        console.log("sweet");

        $(that).fadeOut('fast', function(){
          $(that).parent().remove();
        });
        $(messageContent).fadeOut('fast', function(){
          $(messageContent).remove();
        });
      }
    });

  });

});