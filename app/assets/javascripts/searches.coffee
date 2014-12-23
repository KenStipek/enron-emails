$(document).bindWithDelay('input', '#quick-search', ->
  if($('#quick-search').val().length > 2)
    $.get('/searches/', { 'id' : $('#quick-search').val() }, {}, 'script')
    $('#paginate').data('enable', 'true')
200
)

$ ->
  if $(window).scrollTop() > $(document).height() - $(window).height() - 50
    that = this
    if($(that).data('enable') == 'true')
      $.get('/searches/', { 'id' : $('#quick-search').val(), 'page' : $(that).data('page') + 1 }, {}, 'script')
      $(that).data('page', $(that).data('page') + 1)
