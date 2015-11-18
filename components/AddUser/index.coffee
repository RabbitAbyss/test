module.exports = class AddUsers

	view: __dirname
	style: __dirname 

	init: ->
		@model.ref 'userId', @model.scope '_session.userId'
		@userId = @model.get 'userId'
		@model.ref 'users', @model.scope 'users'

	setUserName: ->
		userName = @model.get 'userName'

		if userName
			@model.set "users.#{@userId}",
				userName: userName,
				professor: false,
				inGame: false
				inGamePlayerId: "none"
				inGameId: "none"

			@model.del 'userName'
		else
			alert 'Name cannot be empty!'

	kikUsers: ->
		for key of @model.get 'users'
			@model.del "users.#{key}"