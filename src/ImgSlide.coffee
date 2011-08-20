class ImgSlide
	
	changeSlide: (slideData) ->
    if $("#slideContainer img").length == 0
      $("#slideContainer").empty()
      $("#slideContainer").append("<img width='100%' heigth='100%' src='" + slideData.url + "'>")
    else
      $("#slideContainer img")[0].setAttribute("src", slideData.url)
    return
