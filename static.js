var static = require('node-static');

var fileServer = new static.Server('./dist');
var port = process.env.PORT || 5000;

require('http').createServer(function (request, response) {
    request.addListener('end', function () {
        fileServer.serve(request, response);
    }).resume();
}).listen(port);