# NoSlide slide plugin is a Null Object pattern implementation for when there is no actual slide to show, 
# e.g.: when the presentation video contains the slides and user just whishes to split it into chapters
class NoSlide

  # Called by presentz when looking up a proper slide plugin
  handle: (slide) ->
    return !slide.url?

  # Does nothing, obviously
  changeSlide: () ->
    return

root = exports ? window
root.presentz = {} if !root.presentz?
root.presentz.NoSlide = NoSlide
