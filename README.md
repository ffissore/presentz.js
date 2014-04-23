# Presentz.js

Presentz.js is a javascript library for synchronizing videos and slides.

It's at the heart of http://presentz.org/, a website for freely publishing conference talks, pitches, lessons and the like. Presentz.org is free software as well, hosted on [github](https://github.com/ffissore/presentz.org).

There is also an [API reference](http://ffissore.github.io/presentz.js).

## Dependencies quick reference

(skip if you are still not using presentz.js but just reading this README)

Depending on which video and slide sources you are using, you need zero to a couple of additional js libraries

- [JQuery](http://jquery.com/)
- [SWFObject](https://code.google.com/p/swfobject/): if your slides are made with flash or if they are hosted on slideshare
- [Froogaloop](http://developer.vimeo.com/player/js-api): if your video is on Vimeo
- [Mediaelementjs](http://mediaelementjs.com/): if you host your video files on your own. There are also .css files and images to setup a good looking player, so using medialementjs requires some additional effort.

Since the following APIs cannot be bundled*, Presentz.js will load them on its own
- [Youtube IFrame API](https://developers.google.com/youtube/iframe_api_reference)

(*) It's either technically or legally impossible or unconvenient

## A JSON file

Presentz.js starts with a presentation, a json object whose structure is

```json
{
  "title": "Video tag, images as slides",
  "chapters": [
    {
      "title": "Part 1",
      "duration": 21,
      "video": {
        "url": "http://presentz.org/assets/demo/demo1.webm",
        "thumb": "http://presentz.org/assets/demo/videotag-img.png"
      },
      "slides": [
        {
          "url": "http://presentz.org/assets/demo/slide1.png",
          "time": 0
        },
        {
          "url": "http://presentz.org/assets/demo/slide2.png",
          "time": 7
        },
        {
          "url": "http://presentz.org/assets/demo/slide3.png",
          "time": 9.5
        },
        {
          "url": "http://presentz.org/assets/demo/slide4.png",
          "time": 14
        }
      ]
    }
  ]
}
```

(A slightly richer version of this presentation can be seen at http://presentz.org/demo/01_videotag-img)

In essence:

- each presentation has a `title` and a list of `chapters`
- each chapter has
  - a `duration` (expressed in seconds)
  - a `video` with a `url`
  - a list of `slides`
- each slide has a `url` and a `time` (expressed in seconds)

The most important information is the `time` of a slide: it's used to determine when a slidechange has to occur and which slide has to be displayed. Such time is relative to the video of the containing chapter.

## Events

You can listen to the events emitted by Presentz.js with the syntax `.on(eventName, function(){...})`

Presentz.js emits the following events:
- `slidechange`, emitted when the slide changes. Callback arguments: `oldChapterIndex`, `oldSlideIndex`, `newChapterIndex`, `newSlideIndex`
- `videochange`, emitted when the chapter changes. See `slidechange` callback arguments
- `timechange`, emitted as the video player plays the video. Callback argument: `currentTime` (a float)

## Supported video sources

Presentz.js wants to use and reuse everything is already available, but we can rely only on those video streaming services that provide a "player API". As a fallback, we can host our video files on our own servers (or on any other webserver, think amazon s3, dropbox...)

At the moment, Presentz.js supports Youtube, Vimeo and raw video sources (as in the JSON above).

### Youtube

Use the youtube url in the `video.url` property

```json
"video": {
  "url": "http://youtu.be/hJgncy4I1ig",
  "thumb": "/assets/demo/youtube-slideshare.png"
},
```

Works with both the long url `http://www.youtube.com/watch?v=hJgncy4I1ig` and the short one `http://youtu.be/hJgncy4I1ig`

### Vimeo

Use the vimeo url in the `video.url` property

```json
"video": {
  "url": "http://vimeo.com/27902834",
  "thumb": "/assets/demo/vimeo-img.png"
},
```

### Samba Tech

Use the samba tech url in the `video.url` property and set the plugin ID.
```json
"video": {
  "url": "http://player.sambatech.com.br/current/samba-player.js?ph=1848c0c4b30b5d2d886ef99546152c23&m=449ead8b6768bb8ec73a8ef579d175f3",
  "_plugin_id": "sambatech_plugin",
  "thumb": "/assets/demo/vimeo-img.png"
},
```
[Samba Tech](http://sambatech.com) is a online video platform pioneer in Latin America used by media groups, enterprises and universities.

### Wistia

Use the wistia url in the `video.url` property and set the plugin ID.
```json
"video": {
  "url": "http://www.wistia.com/g3q48tbnyg",
  "_plugin_id": "wistia_plugin",
  "thumb": "/assets/demo/vimeo-img.png"
},
```
[Wistia](http://www.wistia.com) provides a video hosting application that makes it easy to manage, share, and track video at work.


### Raw video files

Use the url to the video file in the `video.url` property

```json
"video": {
  "url": "http://presentz.org/assets/demo/demo1.webm",
  "thumb": "http://presentz.org/assets/demo/videotag-img.png"
},
```

Raw video files require mediaelementjs is already setup (if you just put in their .js file, the player will be so ugly to be unusable)

## Supported slide sources

### Images and SWF files

You can export a presentation made with [LibreOffice](https://www.libreoffice.org/) to images (should be "File -> Export -> HTML Document"). Or you can convert a PDF to a series of SWF with [SWFTools](http://www.swftools.org/).

Either way, once you have your files, put the url in the `slide.url` property

```json
{
  "url": "http://presentz.org/assets/demo/slide1.png",
  "time": 0
},
```

### SlideShare

Slideshows on slideshare are identified by an ID they call `PPTLocation` (in their [API](http://www.slideshare.net/developers/documentation#get_slideshow)) and `doc` (in their [player API](http://www.slideshare.net/developers/playerapi)).

Use that ID to compose a fake slideshare URL, like

```json
{
  "url": "http://www.slideshare.net/slides-110818145820-phpapp02#1",
  "public_url": "http://www.slideshare.net/federicofissore/presentz-demo-slides"
  "time": 0
},
```

where:
- `http://www.slideshare.net` is used to activate the slideshare plugin
- `slides-110818145820-phpapp02` is the ID (or doc, or PPTLocation)
- `#1` is the slide number (one based)
- `http://www.slideshare.net/federicofissore/presentz-demo-slides` is the url to access the slide show on slideshare

If the `public_url` is present, presentz.js will NOT use the flash player (hurrah!) instead will pick the JPGs provided by SlideShare's [oEmbed API](http://www.slideshare.net/developers/oembed). It's therefore highly recommended to provide a `public_url`

### Speakerdeck

Slideshows on speakerdeck are identified by an ID but, unfortunately, there is yet no public API to have this ID from the slideshow public url. You can get it by clicking the "Embed" link on the right of a slideshow, "Embed" again and looking for a `data-id` attribute in the `<script../>` snippet just below.

Use that ID to compose a fake speakerdeck URL, like

```json
{
  "url": "https://speakerdeck.com/4ffbeed2df7b3f00010233bf#1",
  "time": 0
},
```

where:
- `https://speakerdeck.com` is used to activate the speakerdeck plugin
- `4ffbeed2df7b3f00010233bf` is the ID
- `#1` is the slide number (one based)

### Rvl.io, Reveal.js, DZSlides and other hash/javascript/brower based slide systems that can fit into an IFrame

[Reveal.js](http://lab.hakim.se/reveal-js/), [Rvl.io](http://www.rvl.io/) and [DZSlides](http://paulrouget.com/dzslides/) are some popular frameworks for creating very good looking HTML + CSS based slideshows.

As they monitor the URL to know which slide has to be displayed, presentz.js supports them by wrapping the slideshow into an IFrame and changing its url.

Each of these system has its own way of understanding which slide to display. See the following examples:

#### Rvl.io and Reveal.js

```json
{
  "url": "http://www.rvl.io/federico/presentz/#/0",
  "time": 0,
  "_plugin_id": "iframe"
}
```

where:
- `http://www.rvl.io/federico/presentz/` is the base url
- `#/0` is the slide number (zero based)
- `"_plugin_id": "iframe"` is used to force presentz.js use the IFrameSlide plugin (otherwise the fallback ImageSlide would be used

Reveal.js supports vertical slides, that are a sort of "sub slides" of a parent one. To show those slides, append the number to the parent slide number, for example

```json
{
  "url": "http://www.rvl.io/federico/presentz/#/0/1",
  "time": 10,
  "_plugin_id": "iframe"
}
```

#### DZSlides

```json
{
  "url": "http://www.mozillaitalia.org/slides/linuxday12/#1.0",
  "time": 0,
  "_plugin_id": "iframe"
}
```

where:
- `http://www.mozillaitalia.org/slides/linuxday12/` is the base url
- `#1.0` is the slide number (one based)
- `"_plugin_id": "iframe"` is used to force presentz.js use the IFrameSlide plugin (otherwise the fallback ImageSlide would be used

### Plugin override

Presentz.js tries to understand which plugins fits best by looking at the video/slide url. If you wish to force usage of a particular plugin, add the slide/video json object a `_plugin_id` field. For example:

```json
{
  "url": "http://www.mozillaitalia.org/slides/linuxday12/#1.0",
  "time": 0,
  "_plugin_id": "iframe"
}
```

Allowed values include:
- video: "vimeo", "youtube", "html5"
- slide: "slideshare", "speakerdeck", "swf", "image", "iframe"

### Adding your plugin

By calling methods `Presentz.registerVideoPlugin(id, plugin)` and `Presentz.registerSlidePlugin(id, plugin)` (before calling the `init` method) you can make presentz.js work with your own plugin.

If you think you plugin can be of benefit to presentz.js users, consider making a pull request and have included in the official distribution.

### Reference

You can browse the reference documentation at http://ffissore.github.io/presentz.js

License
-----------
Copyright (C) 2012 Federico Fissore

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
