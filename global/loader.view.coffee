define ->

  LoaderView = Backbone.View.extend
    show: (onComplete) ->
      TweenLite.fromTo @$el, 0.16, { opacity: 0 }, { opacity: 1, ease: Power2.easeOut, onComplete: => @$el.css opacity: ""; onComplete?() }
    hide: (onComplete, delay) ->
      TweenLite.to @$el, 0.16, { delay: delay, opacity: 0, ease: Power2.easeOut, onComplete: => @$el.css opacity: ""; onComplete?() }

  add: ($element, className) ->
    deffer = $.Deferred()
    loaderView = new LoaderView className: className
    preLoadTimeout = setTimeout =>
      loaderView.show()
      $element.append loaderView.$el
    , 60
    preLoaderTime = (new Date).getTime()
    deffer.promise().done (done, access) =>
      unless access
        if ( (new Date).getTime() - preLoaderTime ) < 60
          clearTimeout preLoadTimeout
          done()
          loaderView.remove()
        else
          loaderView.hide =>
            done()
            loaderView.remove()
          , 0.6
    deffer