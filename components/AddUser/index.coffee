module.exports = class AddUsers

	view: __dirname
	style:  __dirname 

	init: ->
		@model.ref 'userId', @model.scope '_session.userId'
		@userId = @model.get 'userId'
		@model.ref 'users', @model.scope 'users'

	KillAll: ->
		for key of @model.get 'users'
			@model.del "users.#{key}"

	setUserName: ->
		userName = @model.get 'userName'
		
		if userName?
			userName = userName.trim()
		
		if userName
			@model.set "users.#{ @userId }",
				userName: userName,
				professor: false,
			@model.del 'userName'
		else
			alert 'Name cannot be empty!'

	Professor: ->
		Prof = @model.get 'Prof'
		@model.set "users.#{ @userId }.professor", Prof
