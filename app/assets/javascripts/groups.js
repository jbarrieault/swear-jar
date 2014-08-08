$(function(){
  $('#triggers').on('click', '.add-trigger', function(){
    var newTriggerBox;
    newTriggerBox = $(this).closest('p.trigger').clone();
    newTriggerBox.find('input').val('');
    
    $(this).closest('div#triggers').
      append(newTriggerBox);
    
    // perhaps made the input hidden after
    // and populate an element with just the text?
    $(this).closest('p.trigger').
       append('<button class="remove-trigger" type="button">-</button>');
    
    $(this).fadeOut('fast').remove();

    // $(this).fadeOut('fast', function(){
    //   this.remove();
    // });
  });



    $('#triggers').on('click', '.remove-trigger', function(){
      // bottom input should always be empty with a + button
     
      $(this).closest('p.trigger').
        fadeOut(200, function(){
          this.remove()
        }); //make sure not in params
      
    });

});