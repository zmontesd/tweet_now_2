$(document).ready(function() {
  $('form').on('submit', function(e) {
    e.preventDefault();
    $('form').hide();
    $('#tweet').append("<p id='status'>tweeting......</p>");
    $.ajax({
      url: '/tweet',
      type: 'post',
      data: { content: $('#content').val() }
    }).done(function(result) {
      $('#status').hide();
      $('#tweet').append('success');
    }).fail(function(result) {
      $('#status').hide();
      $('#tweet').append('failed');
    });
  });
});
