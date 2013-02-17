class RvlIO extends IFrameSlide

  handle: (slide) ->
    return false if !slide.url?
    slide.url.toLowerCase().indexOf("rvl.io") isnt -1
