$(function(){

  // JOIN BUTTON
  $('.join-btn').on('click', '.nonmember', function(){ 
    var group_id = $(this).attr('id');
    var that = $(this);
    
    $(this).attr('class', 'member btn btn-default leave-btn-grey');
    $(this).text('Leave');

    $.ajax({
      type: 'POST',
      url: '/groups/join',
      data: {group: {id: group_id} },
      success: function(response){
        console.log("joining worked");
      },
      error: function(response){
        that.attr('class', 'nonmember btn btn-default');
        console.log("joining failed");
        $(this).text('Join');
      } 
    });

  });


  // LEAVE BUTTON
  $('.join-btn').on('click', '.member', function(){
    var group_id = $(this).attr('id');
    var that = $(this);
 
    $(this).attr('class', 'nonmember btn btn-default nonmember-btn-green');
    $(this).text('Join');

    $.ajax({
      type: 'POST',
      url: '/groups/leave',
      data: {group: {id: group_id} },
      success: function(response){
        console.log("leaving worked");

      },
      error: function(response){
        console.log("leaving failed");
        $(this).text('Leave');
      }
    });

  });

  // CLOSE BTN
  $('.join-btn').on('click', '.admin', function(){
    var group_id = $(this).attr('id');
    var that = $(this);
 
    $(this).attr('class', 'nonmember btn btn-default');
    $(this).child.attr('class', 'closed')
    
    if (confirm("Are you sure you want to close this group?")){
      $(this).closest('li').hide();

      $.ajax({
        type: 'PATCH',
        url: '/groups/'+group_id+'/close',
        data: {group_id: group_id },
        success: function(response){
          console.log("closing worked");
          that.closest('li').remove();

        },
        error: function(response){
          console.log("closing failed");
          that.closest('li').show();
        }
      });

    } 

  });





});