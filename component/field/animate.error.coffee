define [
], (
) ->

  class AnimateError
    constructor: ($template, selectors, startParams) ->
      @paramsCache = { }
      for selector in selectors
        @paramsCache[selector] = { }
        @paramsCache[selector].$element = $template.find(selector)
        @paramsCache[selector].$parent = @paramsCache[selector].$element.parent()
        @paramsCache[selector].params = complate: 0, height: 0, opacity: 0, translateY: -30, translateZ: -33, rotateX: 90
  
    showAnimate: (selector) ->
      return if @paramsCache.current is selector
      contain = if @paramsCache.current then on
      @hideAnimate @paramsCache.current, on if @paramsCache.current
      @paramsCache.current = selector
      params = @paramsCache[selector].params
      $element = @paramsCache[selector].$element
      $parent = @paramsCache[selector].$parent
      TweenLite.to params, 0.3,
        onStart: -> $parent.css perspective: "900px", transformStyle: "preserve-3d"
        complate: 100
        height: 33
        translateY: 0
        translateZ: 0
        opacity: 1
        rotateX: 0
        ease: Power0.easeInOut
        onUpdate: ->
          $parent.css height: "#{params.height}px" unless contain
          $element.css opacity: params.opacity, transform: "translateY(#{params.translateY}%) translateZ(#{params.translateZ}px) rotateX(#{params.rotateX}deg)", transformOrigin: "0% #{params.complate}%"
        onComplete: ->
          $parent.css perspective: "", transformStyle: ""
          $element.css transform: "", transformOrigin: ""
  
    hideAnimate: (selector, current) ->
      return unless @paramsCache.current is selector
      @paramsCache.current = null
      params = @paramsCache[selector].params
      $element = @paramsCache[selector].$element
      $parent = @paramsCache[selector].$parent
      params.height = $parent.height()
      TweenLite.to params, 0.3,
        onStart: -> $parent.css perspective: "900px", transformStyle: "preserve-3d"
        complate: 0
        height: 0
        translateY: -30
        translateZ: -33
        opacity: 0
        rotateX: 90
        ease: Power0.easeInOut
        onUpdate: ->
          $parent.css height: "#{params.height}px" unless current
          $element.css opacity: params.opacity, transform: "translateY(#{params.translateY}%) translateZ(#{params.translateZ}px) rotateX(#{params.rotateX}deg)", transformOrigin: "0% #{params.complate}%"
        onComplete: ->
          $parent.css perspective: "", transformStyle: ""
          $element.css opacity: "", transform: "", transformOrigin: ""