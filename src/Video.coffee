class Video

  constructor: (@playStates, @pauseStates, @finishStates, @presentz) ->
    @isInPauseState = true

  handleEvent: (event) ->
    if event in @playStates
      @presentz.startTimeChecker()
    else if event in @pauseStates or event in @finishStates
      @presentz.stopTimeChecker()

    if event in @finishStates and @presentz.currentChapterIndex < (@presentz.howManyChapters - 1)
      @presentz.changeChapter(@presentz.currentChapterIndex + 1, 0, true)

    @isInPauseState = event in @pauseStates

    return
    
  isPaused: () ->
    @isInPauseState