class ImgSlide
  
  changeSlide: (slide) ->
    if $("#slideContainer img").length == 0
      slideContainer = $("#slideContainer")
      slideContainer.empty()
      slideContainer.append("<img width='100%' height='100%' src='#{slide.url}'>")
      @sizer = new Sizer(slideContainer.width(), slideContainer.width(), "slideContainer")
    else
      $("#slideContainer img")[0].setAttribute("src", slide.url)
    return
    
  adjustSize: () ->
    newSize = @sizer.optimalSize()
    img = $("#slideContainer img")
    if img.width() != newSize.width
      img[0].setAttribute("width", newSize.width)
      img[0].setAttribute("height", newSize.height)
