define [

], (

) ->

  class RenderTemplate
    constructor: (viewsNames) ->
      @state = new Object
      @state[viewName] = new Object for viewName in viewsNames

      return (routingSettings) =>
        for stateName, state of @state
          (($parent = $(stateName).parent().last(), $view = $parent.find(stateName)) ->
            if routingSettings[stateName]
              $parent = $(stateName).parent()
              if state.template
                if routingSettings[stateName].template isnt state.template
                  "update"
                  $viewPre = state.$view
                  $viewNew = $view.cloneElement()
                  $viewNew.append(routingSettings[stateName].template)
                  $parent.append($viewNew)
                  TweenLite.fromTo $viewPre, 1, { zIndex: 0 }, { rotationY: 60, x: "-100%", z: 200, opacity: 0, onComplete: -> $viewPre.remove() }
                  TweenLite.fromTo $viewNew, 1, { zIndex: 1, rotationY: -60, x: "100%", z: 200, opacity: 0 }, { rotationY: 0, x: "0%", z: 0, opacity: 1, onComplete: -> $viewNew.css zIndex: "", transform: "", opacity: ""; }
                  state.$view = $viewNew
                  state.template = routingSettings[stateName].template
                else
                  "static"
              else
                "render"
                $view.append(routingSettings[stateName].template)
                TweenLite.fromTo $view, 0.3, { opacity: 0 }, { opacity: 1, onComplete: -> $view.css opacity: ""; }
                state.$view = $view
                state.template = routingSettings[stateName].template
            else
              TweenLite.fromTo state.$view, 0.3, { opacity: 1 }, { opacity: 0, onComplete: -> } if state.template
              delete state.$view
              delete state.template
          )()