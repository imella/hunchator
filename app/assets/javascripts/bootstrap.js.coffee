jQuery ->
  $("a[rel=popover]").popover()
  $("div[rel=popover]").popover
  	placement: 'bottom'
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()