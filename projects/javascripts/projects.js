$(function() {
  $('.description:first').show();

  $('li.project a').click(function() {
    var $descriptions = $('.description');
    $descriptions.hide();

    $('li.project').removeClass('selected');
    $(this).parent().addClass('selected');

    var showId = $(this).attr('href');
    $(showId).show();

    return false;
  });
});
