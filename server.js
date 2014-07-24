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

// Main views
app.get('/dashboard', function(req, res){
	res.render("dashboard");
});
app.get('/backup-codes', function(req, res){
	res.render("backup-codes");
});

// Partials
app.get('/devices/device-view', function(req, res){
	res.render("dashboard/devices/device-view");
});
app.get('/devices/device-new-1', function(req, res){
	res.render("dashboard/devices/device-new-1");
});
app.get('/devices/device-new-2', function(req, res){
	res.render("dashboard/devices/device-new-2");
});
app.get('/devices/device-new-3', function(req, res){
	res.render("dashboard/devices/device-new-3");
});
app.get('/phonelines/phoneline-view-cellphone', function(req, res){
	res.render("dashboard/phonelines/phoneline-view-cellphone");
});
app.get('/phonelines/phoneline-view-landline', function(req, res){
	res.render("dashboard/phonelines/phoneline-view-landline");
});
app.get('/phonelines/phoneline-new-1', function(req, res){
	res.render("dashboard/phonelines/phoneline-new-1");
});
app.get('/phonelines/phoneline-new-2', function(req, res){
	res.render("dashboard/phonelines/phoneline-new-2");
});
app.get('/phonelines/phoneline-new-3', function(req, res){
	res.render("dashboard/phonelines/phoneline-new-3");
});
app.get('/integrations/integration-view', function(req, res){
	res.render("dashboard/integrations/integration-view");
});
app.get('/integrations/integration-new', function(req, res){
	res.render("dashboard/integrations/integration-new");
});
app.get('/integrations/integration-edit', function(req, res){
	res.render("dashboard/integrations/integration-edit");
});

// Heroku
var port = process.env.PORT || 5000;
app.listen(port, function() {
	console.log("Listening on " + port);
});