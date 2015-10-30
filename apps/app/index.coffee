derby = require 'derby'

app = module.exports = derby.createApp 'app', __filename

app.use require 'derby-router'
app.use require 'derby-debug'
app.serverUse module, 'derby-jade'
app.serverUse module, 'derby-stylus'

app.component require '../../components/StartGame'
app.component require '../../components/GamesList'
app.component require '../../components/AddGame'
app.component require '../../components/AddUser'
app.component require './component/MainPage'
app.component require './component/Game'

app.loadViews __dirname + '/views'
app.loadStyles __dirname + '/styles'

app.get '/', (page, model) ->
	userId = model.get '_session.userId'
	model.subscribe 'games', 'quant', 'users', ->
		model.at('games').filter().ref '_page.games'
		model.at('users').filter().ref '_page.users'
		model.at('quant').filter().ref '_page.quant'
		console.log 'users', model.get '_page.users'
		console.log 'games', model.get '_page.games'
		console.log 'quant', model.get '_page.quant'
		page.render 'MainPage'

app.get '/end/:gameId', (page, model, params) ->
	end = model.get "games.#{params.gameId}.end"
	if end == false
		gameName = model.get "games.#{params.gameId}.gameName"
		model.set "games.#{params.gameId}.gameName", gameName + ': (END)'
		model.set "games.#{params.gameId}.end", true	
	page.redirect '/'

app.get '/game/:gameId', (page, model, params) ->
	
	model.subscribe 'games.' + params.gameId, 'quant.' + params.gameId, ->
		model.set '_page.gameId', params.gameId
		usersInGame = model.query 'users', 'games.' + params.gameId + '.userIds'
		userId = model.get '_session.userId'

		model.subscribe usersInGame, 'users.' + userId, ->
			model.set '_page.gameId', params.gameId
			model.ref '_page.user', 'users.' + userId
			model.ref '_page.game', 'games.' + params.gameId
			model.ref '_page.professors', 'games.' + params.gameId + '.professors'
			model.ref '_page.players', 'games.' + params.gameId + '.players'
			model.ref '_page.playersQ', 'quant.' + params.gameId + '.players'
			model.ref '_page.player', 'games.' + params.gameId + '.players.' + userId
			model.ref '_page.playerQ', 'quant.' + params.gameId + '.players.' + userId

			unless model.get '_page.player'
				prof = model.get '_page.user.professor' 
				if prof == true
					model.add '_page.professors', {id: userId}
				else
					model.add '_page.players', { id: userId, profit: [], totalProfit: 0  }
					model.add '_page.playersQ', { id: userId, Quantity: []  }			
					model.push '_page.game.userIds', userId

			page.render 'Game'
