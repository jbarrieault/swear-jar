$(function(){

  $('.join-leave').on('click', '.nonmember', function(){ 
    var group_id = $(this).attr('id');
    var that = $(this);
    
    $(this).attr('class', 'member btn btn-primary');
    $(this).text('Leave Group');

    $.ajax({
      type: 'POST',
      url: '/groups/join',
      data: {group: {id: group_id} },
      success: function(response){
        console.log("joining worked");
      },
      error: function(response){
        that.attr('class', 'nonmember');
        console.log("joining failed");
        $(this).text('Join Group');
      } 
    });

  });



  $('.join-leave').on('click', '.member', function(){
    var group_id = $(this).attr('id');
    var that = $(this);
 
    $(this).attr('class', 'nonmember btn btn-primary');
    $(this).text('Join Group');

    $.ajax({
      type: 'POST',
      url: '/groups/leave',
      data: {group: {id: group_id} },
      success: function(response){
        console.log("leaving worked");

      },
      error: function(response){
        console.log("leaving failed");
        that.attr('class', 'member');
        $(this).text('Leave Group');
      }
    });

  });


});