class ImgSlide
  
  changeSlide: (slide) ->
    if $("#slideContainer img").length == 0
      $("#slideContainer").empty()
      $("#slideContainer").append("<img width='100%' src='#{slide.url}'>")
    else
      $("#slideContainer img")[0].setAttribute("src", slide.url)
    return
    

