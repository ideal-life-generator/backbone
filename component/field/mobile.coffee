define [
  "text!component/field/mobile.html"
  "component/field/model"
  "plugin/phone.mask"
  "text!cache/phone.mask.json"
  "component/field/animate.error"
], (
  template
  FieldModel
  PhoneMask
  phoneMask
  AnimateError
) ->

  Backbone.View.extend

    model: new FieldModel

    events:
      "input input": (event) ->
        @animateError.hideAnimate ".empty"
        @model.set result: @phoneMask event

    getValue: ->
      result = @model.get "result"
      if result then result else @animateError.showAnimate(".empty") and undefined

    initialize: ->
      $template = $(template)
      @$el.append $template
      @animateError = new AnimateError $template, [ ".empty" ]
      @phoneMask = new PhoneMask JSON.parse phoneMask