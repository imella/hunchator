# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ ->
  dislikes = []
  likes = []
  blocked = []
  
  resizeImage = (i) ->
    maxWidth = 200              # Max width for the image
    maxHeight = 200             # Max height for the image
    ratio = 0                   # Used for aspect ratio
    width = i.width();    # Current image width
    height = i.height();  # Current image height

    # Check if the current width is larger than the max
    if width > maxWidth
      ratio = maxWidth / width
      i.css("width", maxWidth)
      i.css("height", height * ratio)
      height = height * ratio

    width = i.width()
    height = i.height()

    if height > maxHeight
      ratio = maxHeight / height
      i.css("height", maxHeight)
      i.css("width", width * ratio)
      width = width * ratio

  $('.recommendation-item-img-div').hover( 
    -> 
      $(this).find(".actions").removeClass("dn")
    , -> 
      $(this).find(".actions").addClass("dn"))

  $('.recommendation-item-img').each -> resizeImage $(this)

  # for block in $('.recommendation-item')
  #   blocked.push $(block).data('item-id')
  #   console.log "#{blocked}"

  $(document).on 'click', '.dislike', (e) ->
    e.preventDefault()
    dislikes.push $(@).data('item-id')
    item = $(@).parent().parent().parent()
    item.popover('hide')
    $('#recommendations-container').isotope('remove', item)
    console.log "Dislikes #{dislikes}"


  $(document).on 'click', '.like', (e) ->
    e.preventDefault()
    likes.push $(@).data('item-id')
    item = $(@).parent().parent().parent()
    item.addClass('like-border')
    
    console.log "Likes #{likes}"


  $('#recommendations-container').isotope
    itemSelector : '.recommendation-item'
    
    layoutMode: 'masonry'


    #layoutMode: 'cellsByColumn'
    #cellsByRow:
    #  columnWidth: 240
    #  rowHeight: 360

    
  $('.more').on 'click', (e) ->
    e.preventDefault()
    friend_id = $(@).attr('id')
    $.ajax(
      type: "get"
      url: "/friends/#{friend_id}/recommend"
      dataType: 'json'
      data:
        dislikes: dislikes.join(',')
        likes: likes.join(',')
        # blocked: blocked.join(',')
    ).done (msg) ->
      html = ""
      blocked = []
      for r in msg
        html = ""
        html = "<div class=\"recommendation-item incoming\" rel=\"popover\" title=\"#{r.name}\" data-content=\"#{r.description}\" data-item-id=\"#{r.result_id}\" >"

        html += "<div class=\"recommendation-item-img-div\">"

        html += "<div class=\"actions dn\">"

        html += "<a href=\"#\" class=\"btn btn-success like\" data-item-id=\"#{r.result_id}\">
            <i class=\"icon-ok\"></i>
          </a>
          <a href=\"#\" class=\"btn btn-danger dislike\" data-item-id=\"#{r.result_id}\">
            <i class=\"icon-remove\"></i>
          </a>"

        html += "</div>"
        html += "<a href=\"#\"><img src=\"#{r.image_url}\" class=\"recommendation-item-img incoming-image\" /></a>"
        html += "</div></div>"
        #$(div).html(html)
        $('#recommendations-container').append(html)


        # html += "<div data-item-id=#{r.result_id} class='recommendation'><img src=#{r.image_url} width='100'/></div>"
        # html += "<a href='#' class='btn like' id=like-#{r.result_id}>Like</a>"
        # html += "<a href='#' class='btn btn-danger dislike' id=dislike-#{r.result_id}>Dislike</a>"
        # html += "</div>"

        # blocked.push r.result_id

      $('#recommendations-container').isotope "appended", $('.incoming'), ->
        $('.incoming').popover
          placement: 'bottom'
        $('.incoming-image').each -> resizeImage $(this) 
        $('.incoming').removeClass('incoming')
        $('.incoming-image').removeClass('incoming-image')
        $('#recommendations-container').isotope("reLayout")
        $('.recommendation-item-img-div').hover( 
          -> 
            $(this).find(".actions").removeClass("dn")
          , -> 
            $(this).find(".actions").addClass("dn"))
      # console.log "#{blocked}"
        