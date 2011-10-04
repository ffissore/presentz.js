class Agenda
  constructor: (@agendaContainer) ->
    
  build: (presentation) ->
    totalDuration = 0
    totalDuration += Math.round(chapter.duration) for chapter in presentation.chapters
    widths = computeBarWidths(totalDuration, $("##{@agendaContainer}").width(), presentation.chapters)
    agenda = ''
    for chapterIndex in [0..widths.length-1]
      for slideIndex in [0..widths[chapterIndex].length-1]
        if presentation.chapters[chapterIndex].media.slides[slideIndex].title
          title = presentation.chapters[chapterIndex].media.slides[slideIndex].title
        else
          title = "#{ presentation.chapters[chapterIndex].title } - Slide #{ slideIndex + 1 }"
        agenda += "<div style='width: #{ widths[chapterIndex][slideIndex] }px' onclick='presentz.changeChapter(#{ chapterIndex }, #{ slideIndex }, true);'><div class='progress'></div><div class='info'>#{ title }</div></div>"

    $("##{@agendaContainer}").html(agenda)
    return
    
  select: (presentation, chapterIndex, slideIndex) ->
    $("##{@agendaContainer} div.agendaselected").removeClass("agendaselected")
    
    currentSlideIndex = slideIndex
    for index in [0..chapterIndex-1] when chapterIndex - 1 >= 0  
      currentSlideIndex += presentation.chapters[index].media.slides.length
    $("##{@agendaContainer} div:nth-child(#{currentSlideIndex + 1})").addClass("agendaselected")
    return
    
  computeBarWidths= (duration, maxWidth, chapters) ->
    widths = new Array()
    chapterIndex = 0
    for chapter in chapters
      widths[chapterIndex] = new Array()
      clength = Math.round((chapter.duration * maxWidth / duration) - 1)
      slideWidthSum = 0
      slides = chapter.media.slides
      for slideIndex in [1..slides.length - 1] when slides.length > 1
        slideWidth = Math.round(clength * slides[slideIndex].time / chapter.duration - slideWidthSum) - 1
        slideWidth = if slideWidth > 0 then slideWidth else 1
        slideWidthSum += slideWidth + 1
        widths[chapterIndex][slideIndex - 1] = slideWidth
      widths[chapterIndex][slides.length - 1] = clength - slideWidthSum - 1
      chapterIndex++
    return widths
