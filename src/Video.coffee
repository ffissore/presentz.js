# Video is the common backend of all video plugins.
# It needs to be initialized with play/pause/finish states specific to the actual video plugin.
# The plugin **must** call handleEvent function whenever appropriate
class Video

  # Creates a new Video instance: play/pause/finish states must be arrays, even if they contain only one value
  constructor: (@playStates, @pauseStates, @finishStates, @presentz) ->
    @isInPauseState = true

  # HandleEvent will set isInPlay/Pause/FinishState variables to the proper value 
  handleEvent: (event) ->
    @isInPlayState = event in @playStates
    @isInPauseState = event in @pauseStates or !@isInPlayState
    @isInFinishState = event in @finishStates

    # Then it will start or stop the time check accordingly
    if @isInPlayState
      @presentz.startTimeChecker()
      listeners = @presentz.listeners.play
    else if @isInPauseState or @isInFinishState
      @presentz.stopTimeChecker()
      if @isInPauseState
        listeners = @presentz.listeners.pause
      else if @isInFinishState
        listeners = @presentz.listeners.finish

    listener() for listener in listeners if listeners?

    # Finally it will also call presentz.changeChapter if a video has ended and the presentation contains more videos
    if @isInFinishState and @presentz.currentChapterIndex < (@presentz.presentation.chapters.length - 1)
      @presentz.changeChapter(@presentz.currentChapterIndex + 1, 0, true)

    return

root = exports ? window
root.presentz = {} if !root.presentz?
root.presentz.Video = Video
