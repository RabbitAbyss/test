module.exports = class AddUsers

	view: __dirname

	init: ->
		@model.ref 'userId', @model.scope '_session.userId'
		@userId = @model.get 'userId'

	KillAll: ->
		for key of @model.root.get 'users'
			@model.root.del "users.#{key}"

	setUserName: ->
		userName = @model.get 'userName'
		console.log @userId
		if userName?
			userName = userName.trim()
		if userName
			@model.root.set "users.#{ @userId }.userName", userName
			@model.root.set "users.#{ @userId }.professor", false
			@model.del 'userName'
		else
			alert 'Name cannot be empty!'

	Professor: ->
		Prof = @model.get 'Prof'
		@model.root.set "users.#{ @userId }.professor", Prof
