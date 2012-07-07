# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $(".recommendation").draggable()
  $("#trash").droppable
    drop: (event, ui) ->
      console.log($(ui.draggable)[0].getAttribute("data-item-id"))
      $(ui.draggable).remove()
