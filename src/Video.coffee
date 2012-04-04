class Video

  constructor: (@playState, @pauseState, @finishState, @presentz) ->

  handleEvent: (event) ->
    if event == @playState
      @presentz.startTimeChecker()
    else if event == @pauseState or event == @finishState
      @presentz.stopTimeChecker()

    if event == @finishState and @presentz.currentChapterIndex < (@presentz.howManyChapters - 1)
      @presentz.changeChapter(@presentz.currentChapterIndex + 1, 0, true)

    return
