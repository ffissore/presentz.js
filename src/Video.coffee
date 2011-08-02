class Video
	
	constructor: (@playState, @pauseState, @finishState) ->
	
	handleVideoEvent: (id, event) ->
		if event == @playState
			startTimeChecker()
		else if event == @pauseState or event == @finishState
			stopTimeChecker()
			
		if event == @finishState and chapter < (howManyChapters - 1)
			changeChapter(chapter + 1, true)
