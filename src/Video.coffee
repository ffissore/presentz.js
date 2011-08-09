class Video
  
  constructor: (@playState, @pauseState, @finishState, @presentz) ->

  handleEvent: (event) ->
    if event == @playState
      console.log("start")
      @presentz.startTimeChecker()
    else if event == @pauseState or event == @finishState
      console.log("stop")
      @presentz.stopTimeChecker()
      
    if event == @finishState and @presentz.currentChapterIndex < (@presentz.howManyChapters - 1)
      @presentz.changeChapter(chapter + 1, true)

    return
