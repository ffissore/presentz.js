class NoSlide

  handle: (slide) ->
    return !slide.url?

  changeSlide: () ->
    return

root = exports ? window
root.presentz = {} if !root.presentz?
root.presentz.NoSlide = NoSlide
