# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $(".recommendation").draggable()
  $("#trash").droppable
    drop: (event, ui) ->
      console.log($(ui.draggable)[0].getAttribute("data-item-id"))
      $(ui.draggable).remove()

  $('.recommendation-item-img-div').hover( 
    -> 
      $(this).find(".actions").removeClass("dn")
    , -> 
      $(this).find(".actions").addClass("dn"))

  $('.recommendation-item-img').each ->
    maxWidth = 200              # Max width for the image
    maxHeight = 200             # Max height for the image
    ratio = 0                   # Used for aspect ratio
    width = $(this).width();    # Current image width
    height = $(this).height();  # Current image height
  dislikes = []
  likes = []
  blocked = []

    # Check if the current width is larger than the max
    if width > maxWidth
      ratio = maxWidth / width
      $(this).css("width", maxWidth)
      $(this).css("height", height * ratio)
      height = height * ratio
  for block in $('.recommendation')
    blocked.push $(block).data('item-id')

    width = $(this).width()
    height = $(this).height()
  $('.dislike').on 'click', ->
    dislikes.push $(@).attr('id').replace('dislike-', '')
    $(@).parent().remove()
    console.log "Dislikes #{dislikes}"

    if height > maxHeight
      ratio = maxHeight / height
      $(this).css("height", maxHeight)
      $(this).css("width", width * ratio)
      width = width * ratio
  $('.like').on 'click', ->
    likes.push $(@).attr('id').replace('like-', '')
    console.log "Likes #{likes}"

  $('#recommendations-container').isotope
    itemSelector : '.recommendation-item'
    
    layoutMode: 'masonry'

    #layoutMode: 'cellsByColumn'
    #cellsByRow:
    #  columnWidth: 240
    #  rowHeight: 360

    
  $('.more').on 'click', ->
    friend_id = $(@).attr('id')
    $.ajax(
      type: "get"
      url: "/friends/#{friend_id}/recommend"
      dataType: 'json'
      data:
        dislikes: dislikes.join(',')
        likes: likes.join(',')
        blocked: blocked.join(',')
    ).done (msg) ->
      html = ""
      for r in msg.recommendations
        html += "<div data-item-id=#{r.result_id} class='recommendation'><img src=#{r.image_url} width='100'/></div>"
        html += "<a href='#' class='btn like' id=like-#{r.result_id}>Like</a>"
        html += "<a href='#' class='btn btn-danger dislike' id=dislike-#{r.result_id}>Dislike</a>"
      $('#recommendations').append(html)
        