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
	model.subscribe 'games', 'users', 'players', ->

		model.at('games').filter().ref '_page.games'
		model.at('users').filter().ref '_page.users'
		page.render 'MainPage'

app.get '/end/:gameId', (page, model, params) ->
	end = model.get "games.#{params.gameId}.end"
	if end == false
		model.set "games.#{params.gameId}.end", true
		gameName = model.get "games.#{params.gameId}.gameName"
		model.set "games.#{params.gameId}.gameName", gameName + ': (END)'	
	page.redirect '/'

app.get '/game/:gameId', (page, model, params) ->
	
	model.subscribe "games.#{params.gameId}",  ->
		model.set '_page.gameId', params.gameId
		$players = model.query 'players', {gameId: params.gameId}
		usersInGame = model.query 'users', "games.#{params.gameId}.userIds"
		userId = model.get '_session.userId'

		model.subscribe usersInGame, $players,  ->
			model.set '_page.gameId', params.gameId
			model.ref '_page.game', "games.#{params.gameId}"

			unless model.get "games.#{params.gameId}.players.#{userId}"
				prof = model.get "users.#{userId}.professor" 

				if prof == false
					model.add "games.#{params.gameId}.players", { id: userId, profit: [], totalProfit: 0  }
					model.add 'players', {id: userId, gameId: params.gameId, quant:[]}		
					model.push '_page.game.userIds', userId
				else
					model.push '_page.game.userIds', userId
				

			page.render 'Game'
