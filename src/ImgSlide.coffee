class ImgSlide
  
  changeSlide: (slide) ->
    if @slide == undefined
      $("#slideContainer").empty()
      $("#slideContainer").append("<img width='100%' src='" + slide.url + "'>")
      @slide = $("#slideContainer img")[0]
    else
      @slide.setAttribute("src", slide.url)
    return
    
  isCurrentSlideDifferentFrom: (slide) ->
    @slide.src.lastIndexOf(slide.url) == -1
