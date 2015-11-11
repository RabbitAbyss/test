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
base = require './baseController'

app.loadViews __dirname + '/views'
app.loadStyles __dirname + '/styles'


app.get '/', (page, model) ->
	base.homePage(page, model)

app.get '/end/:gameId', (page, model, params) ->
	base.endGame(page, model, params)

app.get '/game/:gameId', (page, model, params) ->
	base.game(page, model, params)
