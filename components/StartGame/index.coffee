module.exports = class StartGame

	view: __dirname
	style: __dirname
	
	init: ->
		@model.ref 'userId', @model.scope '_session.userId'
		@userId = @model.get 'userId'
		
		@model.ref 'gameId', @model.scope '_page.gameId'
		@gameId = @model.get 'gameId'

		@model.ref 'players', @model.scope 'players'
		@model.ref 'game', @model.scope '_page.game'
		@model.ref 'users', @model.scope 'users'

		@model.start 'res', 'players', @subRound.bind(@)


	format = (x) -> ~~ (x * 10) / 10
	
	startGame: ->
		@model.set 'game.round', 1
		@model.set 'game.started', true
	
	subRound:(players)->

		maxRounds = @model.get 'game.maxRounds'
		rounds = @model.get 'game.round'
		cost = @model.get 'game.costPerRound'
		colPlayers = @model.get 'game.colPlayers'

		colAnswers = null
		res = {}
		res.winner = {
			name: 'none',
			profit: null
		}
		res.price = []
		res.playersIds = []
		res.names = {}
		res.profit = {}
		res.totalProfit = {}

		for player of players
			res.playersIds.push(player) 
			res.names[player] =  @model.get "game.players.#{players[player].userId}.name"
			res.totalProfit[player] = null
			res.profit[player] = []

		#start
		for round in [0..rounds-1]
			if round !=  rounds-1
			
				#Price
				res.price[round] = null
				for player of players
					res.price[round] += players[player].quant[round]
				res.price[round] = format(45 - 0.2 * res.price[round])
				console.log res.price
				
				#profit
				for player of players
					res.profit[player][round] = format(players[player].quant[round] * (res.price[round] - cost))
					#totalProfit
					res.totalProfit[player] += res.profit[player][round]
				for player of players
					res.totalProfit[player] = format(res.totalProfit[player])
				console.log res.profit

			#winner
			for player of players
				if res.winner.profit < res.totalProfit[player]
					res.winner.name = @model.get "game.players.#{players[player].userId}.name"
					res.winner.profit = res.totalProfit[player]

		#col ansvers?
		for player of players
			if players[player].answer is true
				colAnswers++

		#next round?
		if colAnswers is colPlayers
			@model.set 'game.round', rounds + 1
			for player of players
				@model.set "players.#{player}.answer", false
		res

	addQ: ->
			inQ = @model.get 'inQuantity'
			if inQ >= 0 and inQ < 76 	
				players = @model.get 'players'
				for player of players
					if @userId is players[player].userId
						@model.push "players.#{player}.quant", inQ
						@model.set "players.#{player}.answer", true
		
				@model.del 'inQuantity'
				@model.set 'answer', true
			else 
				alert 'Quantity must >= 0 and < 76'