$(function(){

  setStatus = function(elem, action) {
    var id = $(elem).closest('span.waiting').data()['id'];
    var self = elem;
    $.post("/admin/emails/" + id + "/" + action, function(data){
      content = ""
      if(action === "approve") {
        content = '<span class="approved">3</span>'
      } else {
        content = '<span class="rejected">*</span>'
      }

      $(self).closest('span.status').empty().html(content);
    });
  }

  $('span.approve').click(function(){setStatus(this, 'approve')});
  $('span.reject').click(function(){setStatus(this, 'reject')});
});