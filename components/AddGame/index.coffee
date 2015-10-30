module.exports = class AddGame

	view: __dirname 

	init: ->
		@model.ref 'userId', @model.scope '_session.userId'
		@userId = @model.get 'userId'

	addNewGame: ->
		gameName = @model.get 'gameName'
		if @userId?
			gameName = gameName.trim()
		if @userId
			@model.root.set "games.#{ @userId }.gameName", gameName
			@model.root.set "games.#{ @userId }.players", {}
			@model.root.set "games.#{ @userId }.professors", {}
			@model.root.set "games.#{ @userId }.userIds", []
			@model.root.set "games.#{ @userId }.costPerRound", 5
			@model.root.set "games.#{ @userId }.maxRounds," , 8
			@model.root.set "games.#{ @userId }.round", 0
			@model.root.set "games.#{ @userId }.priceInRound", []
			@model.root.set "games.#{ @userId }.winner", {}
			@model.root.set "games.#{ @userId }.end", false

			@model.root.set "quant.#{ @userId }.players", {}

			@model.del 'gameName'
		else
			alert 'GameName cannot be empty!'
			
	delGames: ->
		for key of @model.root.get 'games'
			@model.root.del "games.#{key}"
		for key of @model.root.get 'quant'
			@model.root.del "quant.#{key}"

