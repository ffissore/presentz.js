assert = require "assert"
SwfSlide = require("../src/SwfSlide").presentz.SwfSlide

fake_presentz =
  newElementName: () -> ""

describe "SWF URL parsing", () ->
  slide = null

  beforeEach () ->
    slide = new SwfSlide(fake_presentz)

  it "should handle valid URLs", () ->
    assert(slide.handle({ url: "http://presentz.org/assets/jugtorino/201102_akka/201105071337260726092.swf" }))
    assert(!slide.handle({ url: "http://www.google.com" }))