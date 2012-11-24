class RvlIO extends IFrameSlide

  handle: (slide) ->
    slide.url.toLowerCase().indexOf("rvl.io") isnt -1
