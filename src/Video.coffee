class Video

  constructor: (@playStates, @pauseStates, @finishStates, @presentz) ->
    @isInPauseState = true

  handleEvent: (event) ->
    @isInPlayState = event in @playStates
    @isInPauseState = event in @pauseStates or !@isInPlayState
    @isInFinishState = event in @finishStates

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

    if @isInFinishState and @presentz.currentChapterIndex < (@presentz.howManyChapters - 1)
      @presentz.changeChapter(@presentz.currentChapterIndex + 1, 0, true)

    return
