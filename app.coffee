define [
  "global/render.template"
  "global/loader.view"
  "plugin/phone.mask"
  "component/field/first.name"
  "component/field/last.name"
  "component/field/mobile"
  "component/field/age"
  "component/field/gender"
], (
  RenderTemplate
  LoaderView
  PhoneMask
  FirstName
  LastName
  Mobile
  Age
  Gender
) ->

  $(->

    # SliderRoute = Backbone.Router.extend
    #   routes:
    #     "slide/:photo": (photoCount) ->
    #       $sliderTemplate.find(".slider-img").attr "src": photos[photoCount].src
    #       homeTemplates
    #         ".slide-state":
    #           template: $sliderTemplate[0].outerHTML
    #         ".gallery-state": off

    #     "slide/:photo/gallery?start=:start&end=:end": (photoCount, photoStart, photoEnd) ->
    #       $sliderTemplate.find(".slider-img").attr "src": photos[photoCount].src
    #       homeTemplates
    #         ".slide-state":
    #           template: $sliderTemplate[0].outerHTML
    #         ".gallery-state":
    #           template: $galleryTemplate[0].outerHTML

    persons = [
        id: 0, first_name: "Vladislav", last_name: "Tkachenko", phone: "+380936124991", gender: "male", age: "27"
      ,
        id: 1, first_name: "Kristina", last_name: "Tkachenko", phone: "", gender: "female", age: "21"
    ]

    UserModel = Backbone.Model.extend
      url: "/documents/7/notes/101"
      defaults: ->
        first_name: new String
        last_name: new String
        phone: new String
        age: new String
        gender: new String

    UserView = Backbone.View.extend
      tagName: "div"
      className: "my-tr"
      template: _.template "
        <div class=\"my-td\">
          <span>{first_name}</span>
        </div>
        <div class=\"my-td\">
          <span>{last_name}</span>
        </div>
        <div class=\"my-td\">
          <span>{phone}</span>
        </div>
        <div class=\"my-td\">
          <span>{age}</span>
        </div>
        <div class=\"my-td\">
          <span>{gender}</span>
        </div>
        <div class=\"my-td\">
          <button class=\"button tiny radius expand\" tabindex=\"1\">
             Delete
          </button>
        </div>
      "
      events:
        "click button": ->
          @model.destroy()

      render: ->
        @$el.append @template @model.toJSON()

      initialize: ->
        @listenTo @model, "destroy", @remove
        @render()

    UsersCollection = Backbone.Collection.extend
      model: UserModel
      comparatorProp: "first_name"

      comparator: (user) ->
        user.get @comparatorProp
          .toLowerCase()

      setComparator: (propName) ->
        @comparatorProp = propName
        @sort()

    UsersView = Backbone.View.extend
      el: "#user-list"
      collection: new UsersCollection persons

      events:
        "click #first-name-header": ->
          @collection.setComparator "first_name"
        "click #last-name-header": ->
          @collection.setComparator "last_name"
        "click #phone-header": ->
          @collection.setComparator "phone"
        "click #age-header": ->
          @collection.setComparator "age"
        "click #gender-header": ->
          @collection.setComparator "gender"
        "click #create-user-header": ((params) =>
          ->
            if @creationMenuActive
              @creationMenuActive = off
              params.height = @$creationMenuWrap.height()
              TweenLite.to params, 0.3,
                onStart: =>
                  @$creationMenuWrap.css perspective: "1600px", transformStyle: "preserve-3d"
                height: 0
                opacity: 0
                translateY: -47
                translateZ: -23.5
                rotateX: 90
                ease: Power0.easeInOut
                onUpdate: =>
                  @$creationMenuWrap.css height: "#{params.height}px"
                  @$creationMenu.css opacity: params.opacity, transform: "translateY(#{params.translateY}%) translateZ(#{params.translateZ}px) rotateX(#{params.rotateX}deg)"
                onComplete: =>
                  @$creationMenuWrap.css perspective: "", transformStyle: ""
                  @$creationMenu.css opacity:"", transform: ""
            else
              @creationMenuActive = on
              TweenLite.to params, 0.3,
                onStart: =>
                  @$creationMenuWrap.css perspective: "1600px", transformStyle: "preserve-3d"
                height: @$creationMenu.height()
                opacity: 1
                translateY: 0
                translateZ: 0
                rotateX: 0
                ease: Power0.easeInOut
                onUpdate: =>
                  @$creationMenuWrap.css height: "#{params.height}px"
                  @$creationMenu.css opacity: params.opacity, transform: "translateY(#{params.translateY}%) translateZ(#{params.translateZ}px) rotateX(#{params.rotateX}deg)"
                onComplete: =>
                  @$creationMenuWrap.css perspective: "", transformStyle: "", height: "100%"
                  @$creationMenu.css transform: ""
                  @firstName.$el.focus()
        )(height: 0, opacity: 0, translateY: -47, translateZ: -23.5, rotateX: 90)

        "click #add-user": ->
          firstName = @firstName.getValue()
          lastName = @lastName.getValue()
          mobile = @mobile.getValue()
          age = @age.getValue()
          gender = @gender.getValue()
          if firstName and lastName and mobile and age and gender
            @collection.create
              first_name: firstName
              last_name: lastName
              phone: mobile
              age: age
              gender: gender

      addUser: (user) ->
        userView = new UserView model: user
        @$list.prepend userView.$el

      render: ->
        @$list.empty()
        @collection.each (user) ->
          userView = new UserView model: user
          @$list.append userView.$el
        , @

      initialize: ->
        @$list = @$el.find("#list")
        @$creationMenu = @$el.find("#creation-menu")
        @$creationMenuWrap = @$creationMenu.parent("#creation-menu-wrap")

        @firstName = new FirstName el: $("#first-name")
        @lastName = new LastName el: $("#last-name")
        @mobile = new Mobile el: $("#phone")
        @age = new Age el: $("#age")
        @gender = new Gender el: $("#gender")

        @listenTo @collection, "sort", @render
        @listenTo @collection, "add", @addUser
        @render()

    new UsersView
  
    Backbone.history.start()
  
    TweenLite.fromTo $("body"), 1, { opacity: 0 }, { opacity: 1, onComplete: -> $("body").css opacity: "" }
  
  )