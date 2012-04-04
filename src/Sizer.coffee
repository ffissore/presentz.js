class Sizer

  constructor: (@startingWidth, @startingHeight, @containerName) ->

  optimalSize: () ->
    newHeight = $(window).height() - ($("div.container div.header").height() + $("div.container div.controls").height()) * 2
    newWidth = Math.round(@startingWidth / @startingHeight * newHeight)
    containerWidth = $("##{@containerName}").width()
    if newWidth > containerWidth
      newWidth = containerWidth
      newHeight = Math.round(@startingHeight / @startingWidth * newWidth)
    result =
      width: newWidth
      height: newHeight
    return result
