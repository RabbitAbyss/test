module.exports = class GamesList

	view: __dirname
	style: __dirname

	init: -> 
		@model.ref 'games', @model.scope '_page.games'