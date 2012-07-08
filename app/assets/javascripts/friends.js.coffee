# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $(".recommendation").draggable()
  $("#trash").droppable
    drop: (event, ui) ->
      console.log($(ui.draggable)[0].getAttribute("data-item-id"))
      $(ui.draggable).remove()


  dislikes = []
  likes = []
  blocked = []

  for block in $('.recommendation')
    blocked.push $(block).data('item-id')

  $('.dislike').on 'click', ->
    dislikes.push $(@).attr('id').replace('dislike-', '')
    $(@).parent().remove()
    console.log "Dislikes #{dislikes}"

  $('.like').on 'click', ->
    likes.push $(@).attr('id').replace('like-', '')
    console.log "Likes #{likes}"


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
        