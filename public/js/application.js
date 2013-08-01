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
       window.location.href = '/';
    }).fail(function(result) {
      $('#status').hide();
      $('#tweet').append('failed');
    });
  });

  $(document).on('click', '.job', function(e){
    e.preventDefault();
    $.ajax({
      url: $(this).attr('href'),
      type: 'get',
    }).done(function(result){
      console.log(result);
      $('#text').text(result.tweet.content + ' - Finished?: ' + result.job_status);
    }); 
  });
});
