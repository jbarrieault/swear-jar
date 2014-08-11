$(function(){

  $('.groups-list').on('click', '.nonmember', function(){ 
    var group_id = $(this).attr('id');
    var that = $(this);
    
    $(this).attr('class', 'member');

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

      }
    });

  });


  $('.groups-list').on('click', '.member', function(){
    var group_id = $(this).attr('id');
    var that = $(this);
 
    $(this).attr('class', 'nonmember');

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
      }
    });

  })





});