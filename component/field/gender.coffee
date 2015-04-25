define [
  "text!component/field/gender.html"
  "component/field/model"
  "component/field/animate.error"
], (
  template
  FieldModel
  AnimateError
) ->

  Backbone.View.extend

    model: new FieldModel

    events:
      "input select": (event) ->
        @animateError.hideAnimate ".empty"
        @model.set result: event.target.value

    getValue: ->
      result = @model.get "result"
      if result then result else @animateError.showAnimate(".empty") and undefined

    initialize: ->
      $template = $(template)
      $template.val("")
      @$el.append $template
      @animateError = new AnimateError $template, [ ".empty" ]