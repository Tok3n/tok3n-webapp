var express = require("express"),
    blade = require('blade'),
    app = express();

// Reference
// https://github.com/vincicat/heroku-express
// http://expressjs.com/guide.html
// https://github.com/spadin/simple-express-static-server
// http://devcenter.heroku.com/articles/node-js

// Configuration
app.configure(function(){
	app.use(express.compress());
	app.use(express.static(__dirname + '/web'));
	app.use(express.bodyParser());
	app.use(express.methodOverride());

	app.set('views', __dirname + '/views');
	app.set('view engine', 'blade');
	app.locals.minify = true;
	// app.locals.debug = true;

	// Error Handling
	app.use(express.logger());
	app.use(express.errorHandler({
		dumpExceptions: true, 
		showStack: true
	}));

	//Setup the Route, you are almost done
	app.use(app.router);
});

app.get('/', function(req, res){
	res.render("index");
});

app.get('/dashboard', function(req, res){
	res.render("dashboard");
});

app.get('/backup-codes', function(req, res){
	res.render("backup-codes");
});

// Heroku
var port = process.env.PORT || 5000;
app.listen(port, function() {
	console.log("Listening on " + port);
});