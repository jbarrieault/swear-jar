$(function(){

  $('.groups-list').on('click', '.nonmember', function(){ 
    var group_id = $(this).attr('id');
    var that = $(this);
    
    $(this).attr('class', 'member');
    $(this).text('leave');

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
        $(this).text('join');
      } 
    });

  });


  $('.groups-list').on('click', '.member', function(){
    var group_id = $(this).attr('id');
    var that = $(this);
 
    $(this).attr('class', 'nonmember');
    $(this).text('join');

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
        $(this).text('leave');
      }
    });

  });


  $('.groups-list').on('click', '.admin', function(){
    var group_id = $(this).attr('id');
    var that = $(this);
 
    $(this).attr('class', 'nonmember');
    
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