
//= require modernizr/modernizr
//= require jquery/jquery
//= require foundation
//= require video-js/video
//= require_tree .

; $(function() {
  $(document).foundation();

  $('#d-top-bar [data-d-control=select-all]').on('click', function() {
    $('#d-list .d-list-item input[type=checkbox]').prop('checked', true)
  });

  $('#d-top-bar [data-d-control=select-none]').on('click', function() {
    $('#d-list .d-list-item input[type=checkbox]').prop('checked', false)
  });

  $('#d-controls').on('submit', function(event) {
    var checked = $('#d-list .d-list-item input[type=checkbox]:checked');
    event.preventDefault();

    if (checked.length) {
      $('#d-download').submit();
    }
  });

  $('.d-toggle-file-details').on('click', function() {
    $('.d-file-details').slideUp();
    $(this).next('.d-file-details').slideToggle();
  });
});
