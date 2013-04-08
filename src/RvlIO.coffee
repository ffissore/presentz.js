class RvlIO extends IFrameSlide

  handle: (slide) ->
    return false if !slide.url?
    slide.url.toLowerCase().indexOf("rvl.io") isnt -1

root = exports ? window
root.presentz = {} if !root.presentz?
root.presentz.RvlIO = RvlIO
