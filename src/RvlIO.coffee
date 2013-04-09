# RvlIO slide plugin is only a specialized version of the IFrameSlide
class RvlIO extends IFrameSlide

  # Called by presentz when looking up a proper slide plugin
  handle: (slide) ->
    return false if !slide.url?
    slide.url.toLowerCase().indexOf("rvl.io") isnt -1

root = exports ? window
root.presentz = {} if !root.presentz?
root.presentz.RvlIO = RvlIO
