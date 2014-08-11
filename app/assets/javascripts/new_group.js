$(function(){
  $('#triggers').on('click', '.add-trigger', function(){
    var newTriggerBox;
    newTriggerBox = $(this).closest('p.trigger').clone();
    newTriggerBox.find('input').val('');
    
    $(this).closest('div#triggers').append(newTriggerBox);
        
    $('div#triggers').find('.add-trigger').
      closest('p.trigger').find('input').focus();

    $(this).hide().closest('p.trigger').
       append('<button class="remove-trigger" type="button">-</button>');
    
    $(this).remove();
  });


  $('#triggers').on('click', '.remove-trigger', function(){   
    $(this).closest('p').next().find('input').focus();

    $(this).closest('p.trigger').
      fadeOut(200, function(){
        this.remove();
      });

  });


  $('#triggers').on('keydown', 'p.trigger input:focus', function(e){
    if(e.keyCode == 13){
      e.preventDefault();
      $(this).closest('p').find('button').click();
    }
  });



});