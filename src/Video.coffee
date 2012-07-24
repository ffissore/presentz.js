class Video

  constructor: (@playState, @pauseState, @finishState, @presentz) ->
    @isInPauseState = false

  handleEvent: (event) ->
    if event is @playState
      @presentz.startTimeChecker()
    else if event is @pauseState or event is @finishState
      @presentz.stopTimeChecker()

    if event is @finishState and @presentz.currentChapterIndex < (@presentz.howManyChapters - 1)
      @presentz.changeChapter(@presentz.currentChapterIndex + 1, 0, true)

    @isInPauseState = event is @pauseState

    return
    
  isPaused: () ->
    @isInPauseState