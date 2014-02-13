App.LoginController = Em.Controller.extend
  needs: ["application"]
  email: "admin@example.com"
  password: "password"

  actions:
    login: ->
      data = @getProperties("email", "password")

      errorCallback = (response) =>
        if response.responseJSON
          @set("error", response.responseJSON.error)
        else
          @set("error", "Oops ~! something went wrong")

      successCallback = (response)=>
        userAttributes = {
          id: response.user.id,
          firstName: response.user.first_name,
          lastName: response.user.last_name,
          role: response.user.role,
          color: App.paintBox.getColor()
        }

        if @store.recordIsLoaded("user", userAttributes.id)
          @store.find("user", userAttributes.id).then (user)=>
            @set("controllers.application.currentUser", user)
            @transitionToRoute("index")
        else
          user = @store.createRecord("user", userAttributes)
          @set("controllers.application.currentUser", user)
          @transitionToRoute("index")
      Em.$.post("/api/sessions", data).then successCallback, errorCallback
