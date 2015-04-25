require.config
  paths:
    text: "libs/text"

require [
  "app"
]

$.prototype.cloneElement = ($element) -> $(@[0].cloneNode())

_.templateSettings.interpolate = /\{(.+?)\}/g