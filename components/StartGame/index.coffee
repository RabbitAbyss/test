module.exports = class StartGame

	view: __dirname

	subRound:(players)->
		@model.root.set '_page.game.winner.profit', 0
		gid = @model.root.get '_page.gameId'
		round = @model.root.get "games.#{gid}.round"
		cost = @model.root.get "games.#{gid}.costPerRound"
		winnerS = @model.root.get "games.#{gid}.winner.profit"
		users = @model.root.get "users"
		playersGame = @model.root.get "games.#{gid}.players"

		colPlayers = 2
		profit = 0
		price = 0
		n = 0

		for i of players
			if players[i.toString()].Quantity[parseInt(round)-1]
				n++

		if n == colPlayers
			for i of players
				price += parseInt(players[i.toString()].Quantity[parseInt(round)-1]) 
			price = 45 - 0.2 * price
			for i of players
				profit = parseInt(players[i.toString()].Quantity[parseInt(round)-1]) * (price - parseInt(cost))
				totalProfit = @model.root.get "_page.game.players.#{i}.totalProfit"
				@model.root.set "_page.game.players.#{i}.totalProfit", (parseInt(totalProfit) + Math.floor(profit))
				@model.root.push "_page.game.players.#{i}.profit", Math.floor(profit)
		
			for i of playersGame
				if winnerS == 0
					winnerS = playersGame[i.toString()].totalProfit
					@model.root.set '_page.game.winner.profit', playersGame[i.toString()].totalProfit
					@model.root.set '_page.game.winner.name', users[i.toString()].userName
				if winnerS < playersGame[i.toString()].totalProfit
					winnerS = playersGame[i.toString()].totalProfit
					@model.root.set '_page.game.winner.profit', playersGame[i.toString()].totalProfit
					@model.root.set '_page.game.winner.name', users[i.toString()].userName

			
			@model.root.push "games.#{gid}.priceInRound", Math.floor(price)

			@model.root.set '_page.game.round', round + 1		
			return 0

	startGame: ->
		@model.root.set "_page.game.round", 1
		@model.scope('_page').start 'res', 'playersQ', @subRound.bind(@)

	addQ: ->
		inQ = @model.get 'inQuantity'
		console.log inQ
		if inQ
			@model.root.push '_page.playerQ.Quantity', inQ
			@model.del 'inQuantity'
		else 
			alert 'Quantity cannot be empty!'