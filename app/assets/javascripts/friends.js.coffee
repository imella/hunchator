# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.Hunchator =
  blacklist: []

$ ->

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

    # Check if the current width is larger than the max
    if width > maxWidth
      ratio = maxWidth / width
      $(this).css("width", maxWidth)
      $(this).css("height", height * ratio)
      height = height * ratio

    width = $(this).width()
    height = $(this).height()

    if height > maxHeight
      ratio = maxHeight / height
      $(this).css("height", maxHeight)
      $(this).css("width", width * ratio)
      width = width * ratio

  $('#recommendations-container').isotope
    itemSelector : '.recommendation-item'
    
    layoutMode: 'masonry'

    #layoutMode: 'cellsByColumn'
    #cellsByRow:
    #  columnWidth: 240
    #  rowHeight: 360

    