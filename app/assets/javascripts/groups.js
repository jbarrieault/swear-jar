$(function(){
  $('.trigger+').click(function(e){
    // e.preventDefault();
    var newTriggerInput;
    newTriggerInput = $(this).clone();
    
    $(this).fadeOut('fast').remove();
    $(this).closest('p.trigger').
       append('<button class="trigger-" type="button">-</button>');
 
    $(this).closest('div#triggers').
      append(newTriggerInput);
    });


    $('.trigger-').click(function(e){
      // e.preventDefault();
      // bottom input should always be empty with a + button
      
      $(this).closest('p.trigger').
        remove(); //make sure not in params
      
    });

});