module.exports = class AddGame

	view: __dirname
	style: __dirname 

	init: ->
		@model.ref 'userId', @model.scope '_session.userId'
		@userId = @model.get 'userId'
		@model.ref 'games', @model.scope 'games'
		@model.ref 'players', @model.scope 'players'
		
	addNewGame: ->
		gameName = @model.get 'gameName'
		if @userId
			@model.add 'games',
				gameName: gameName
				professors: {}
				players:[]
				costPerRound: 5
				maxRounds: 4
				round: 0
				colPlayers: 3
				started: false
				end: false
			@model.del 'gameName'
		else
			alert 'GameName cannot be empty!'
			
	delGames: ->
		for key of @model.get 'games'
			@model.del "games.#{key}"
		for key of @model.get 'players'
			@model.del "players.#{key}"

