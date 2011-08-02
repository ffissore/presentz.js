class Presentz
	
	constructor: (@presentation) ->
		@howManyChapters = presentation.chapters.length
		@currentChapterIndex = 0
		
		@totalDuration += parseInt(chapter.duration) for chapter in presentation.chapters
		widths = @computeBarWidths(100, true)
		for chapter in presentation.chapters
			agenda += "<div title='#{ chapter.title }' style='width: #{ widths[chapterIndex] }%' onclick='changeChapter(#{ chapterIndex }, true);'>&nbsp;</div>"
		
		$("#agendaContainer").html(agenda)
		$("#agendaContainer div[title]").tooltip( {effect : "fade", opacity : 0.7})

		firstChapter = presentation.chapters[0];
		firstVideoUrl = firstChapter.media.video.url.toLowerCase()
		if firstVideoUrl.indexOf("http://youtu.be") != -1
			@video = new YouTube
		else if firstVideoUrl.indexOf("http://vimeo.com") != -1
			@video = new Vimeo
		else
			@video = new Html5

	computerBarWidths: (max) ->
		chapterIndex = 0
		widths = []
		sumOfWidths = 0
		
		chapterIndex = 0
		for chapter in @presentation.chapters
			width = chapter.duration * max / @totalDuration
			if width == 0
				width = 1
			widths[chapterIndex] = width
			sumOfWidths += width
			chapterIndex++
		
		maxIndex = 0
		if sumOfWidths > (max - 1)
			chapterIndex = 0
			for chapter in @presentation.chapters
				if widths[chapterIndex] > widths[maxIndex]
					maxIndex = chapterIndex;
				chapterIndex++
		
		widths[maxIndex] = widths[maxIndex] - (sumOfWidths - (max - 1));
		widths;

	changeChapter: (chapterIndex, play) ->
		@currentChapterIndex = chapterIndex
		currentMedia = @presentation.chapters[@currentChapterIndex].media
		@changeSlide(currentMedia.slides[0].slide)
		@video.changeVideo(currentMedia.video, play)

	changeSlide: (slideData) ->
		$("#slideContainer").empty()
		$("#slideContainer").append("<img width='100%' heigth='100%' src='" + slideData.url + "'>")

