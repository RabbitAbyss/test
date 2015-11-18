module.exports = class GamesList

	view: __dirname
	style: __dirname

	init: ->
		@model.ref 'userId', @model.scope '_session.userId'
		@model.ref 'users', @model.scope 'users'
		@model.ref 'games', @model.scope '_page.games'