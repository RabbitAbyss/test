
baseController = {}
baseController.homePage = (page, model) ->
	userId = model.get '_session.userId'
	model.subscribe 'games',"users.#{userId}", -> #"users.#{userId}"
		model.at('games').filter().ref '_page.games'
		user = model.get "users.#{userId}"
		page.render 'MainPage'

baseController.game = (page, model, params) ->
	model.subscribe "games.#{params.gameId}", ->
		model.set '_page.gameId', params.gameId
		$players = model.query 'players', {gameId: params.gameId}
		userId = model.get '_session.userId'
		userName = model.get "users.#{userId}.userName"
		$player = model.query 'players', {gameId: params.gameId, userId: userId}
		model.subscribe $players, $player, "users.#{userId}",  ->
			model.set '_page.gameId', params.gameId
			model.ref '_page.user', "users.#{userId}"
			model.ref '_page.game', "games.#{params.gameId}"

			prof = model.get "users.#{userId}.professor"
			started = model.get "games.#{params.gameId}.started"
			player = $player.get()
			user = model.get "users.#{userId}"

			console.log "in game", user 
	
			model.ref '_page.player', $player

			if !player[0] and !prof and !started
				model.set "users.#{userId}.inGame", true
				model.set "users.#{userId}.inGameId", params.gameId
				model.push "games.#{params.gameId}.players", userId
				model.add 'players', { userId: userId, gameId: params.gameId, name: userName, quant: [], answer: false }, ->	
						page.render 'Game'
						return

			if prof and not model.get "games.#{params.gameId}.professors.#{userId}" 
				model.add "games.#{params.gameId}.professors", { id: userId, name: userName}, ->
					page.render 'Game'
					return
			
			page.render 'Game'

baseController.endGame = (page, model, params) ->
	userId = model.get '_session.userId'
	model.subscribe 'games',"users.#{userId}", -> 
		user = model.get "users.#{userId}"
		end = model.get "games.#{params.gameId}.end"
		
		if user.inGame and (user.inGameId == params.gameId) 
			model.set "users.#{userId}.inGame", false
			model.set "users.#{userId}.inGameId", "none"
			model.set "users.#{userId}.inGamePlayerId", "none"

		unless end
			model.set "games.#{params.gameId}.end", true
			gameName = model.get "games.#{params.gameId}.gameName"
			model.set "games.#{params.gameId}.gameName", gameName + ': (END)'

		page.redirect '/'
	
module.exports = baseController
