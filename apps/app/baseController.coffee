
baseController = {}
baseController.homePage = (page, model) ->
	userId = model.get '_session.userId'
	model.subscribe 'games',"users.#{userId}", -> #"users.#{userId}"
		model.at('games').filter().ref '_page.games'
		page.render 'MainPage'

baseController.game = (page, model, params) ->
	model.subscribe "games.#{params.gameId}", ->
		model.set '_page.gameId', params.gameId
		$players = model.query 'players', {gameId: params.gameId}
		userId = model.get '_session.userId'
		userName = model.get "users.#{userId}.userName"

		model.subscribe $players, "users.#{userId}",  ->
			model.set '_page.gameId', params.gameId
			model.ref '_page.user', "users.#{userId}"
			model.ref '_page.game', "games.#{params.gameId}"

			inPlayers = model.get "games.#{params.gameId}.players.#{userId}"
			prof = model.get "users.#{userId}.professor"
			started = model.get "games.#{params.gameId}.started"
	
			if !inPlayers and !prof and !started
				model.add "games.#{params.gameId}.players", { id: userId, name: userName, quant: [] }
				model.add 'players', { userId: userId, gameId: params.gameId, quant: [], answer: false }

			if prof and not model.get "games.#{params.gameId}.professors.#{userId}" 
				model.add "games.#{params.gameId}.professors", { id: userId, name: userName}
			
			page.render 'Game'

baseController.endGame = (page, model, params) ->
	end = model.get "games.#{params.gameId}.end"
	unless end
		model.set "games.#{params.gameId}.end", true
		gameName = model.get "games.#{params.gameId}.gameName"
		model.set "games.#{params.gameId}.gameName", gameName + ': (END)'
	page.redirect '/'
	
module.exports = baseController
