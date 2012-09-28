# Presentz.js

Presentz.js is a javascript library for synchronizing videos and slides.

## Dependencies quick reference

(skip if you are still not using presentz.js but just reading this README)

Depending on which video and slide sources you are using, you need zero to a couple of additional js libraries

- [SWFObject](https://code.google.com/p/swfobject/): if your slides are made with flash or if they are hosted on slideshare
- [Froogaloop](http://developer.vimeo.com/player/js-api): if your video is on Vimeo
- [Mediaelementjs](http://mediaelementjs.com/): if you host your video files on your own. There are also .css files and images to setup a good looking player, so using medialementjs requires some additional effort.
- [Youtube IFrame API](https://developers.google.com/youtube/iframe_api_reference): if your videos are on youtube

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

### Raw video files

Use the url to the video file in the `video.url` property

```json
"video": {
  "url": "http://presentz.org/assets/demo/demo1.webm",
  "thumb": "http://presentz.org/assets/demo/videotag-img.png"
},
```

Raw video files require mediaelementjs is already setup (if you just put in their .js file, the player will be so ugly to be unusable)