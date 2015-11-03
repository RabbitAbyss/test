module.exports = class StartGame

	view: __dirname
	style: __dirname
	init: ->
		@model.ref 'userId', @model.scope '_session.userId'
		@userId = @model.get 'userId'

		@model.ref 'games', @model.scope 'games'
		@model.ref 'players', @model.scope 'players'
		@model.ref 'game', @model.scope '_page.game'
		@model.ref 'gameId', @model.scope '_page.gameId'
		@model.ref 'users', @model.scope 'users'
		@model.ref 'playerQ', @model.scope "players.#{@userId}.quant" 

	format= (x) -> ~~(x * 10) / 10


	subRound:(players)->
		@model.set 'game.winner.profit', 0
		gid = @model.get 'gameId'
		round = @model.get "game.round"
		cost = @model.get "game.costPerRound"
		winnerS = @model.get "game.winner.profit"
		users = @model.get 'users'
		playersGame = @model.get 'game.players'
		colPlayers = @model.get 'game.colPlayers'
		profit = 0
		price = 0
		n = 0

		for i of players
			if players[i.toString()].quant[parseInt(round)-1]
				n++

		if n == colPlayers
			
			for i of players
				price += parseInt(players[i.toString()].quant[parseInt(round)-1]) 
			price = 45 - 0.2 * price
			
			for i of players
				profit = parseInt(players[i.toString()].quant[parseInt(round)-1]) * (price - parseInt(cost))
				totalProfit = @model.get "game.players.#{i}.totalProfit"
				@model.set "game.players.#{i}.totalProfit", format(parseInt(totalProfit) + profit)
				@model.push "game.players.#{i}.profit", format(profit)
		
			for i of playersGame
				if  winnerS == 0
					winnerS = playersGame[i.toString()].totalProfit
					@model.set 'game.winner',
						profit: playersGame[i.toString()].totalProfit,
						name: users[i.toString()].userName
				if  winnerS < playersGame[i.toString()].totalProfit
					winnerS = playersGame[i.toString()].totalProfit
					@model.set 'game.winner',
						profit: playersGame[i.toString()].totalProfit,
						name: users[i.toString()].userName

			@model.push "game.priceInRound", format(price)
			@model.set 'game.round', round + 1		
			return 0

	startGame: ->
		@model.set "game.round", 1
		@model.start 'res', 'players', @subRound.bind(@)

	addQ: ->
		inQ = @model.get 'inQuantity'
		console.log inQ
		if inQ
			@model.push 'playerQ', inQ
			@model.del 'inQuantity'
		else 
			alert 'Quantity cannot be empty!'