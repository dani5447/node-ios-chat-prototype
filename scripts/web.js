// requirements
var express = require('express');
var http = require('http');
var fs = require('fs');
var https = require('https');
var socketio = require('socket.io');
var path = require('path');

// var sslOptions = {
//   key: fs.readFileSync('./ssl/server.key'),
//   cert: fs.readFileSync('./ssl/server.crt'),
//   ca: fs.readFileSync('./ssl/ca.crt')
// };

// routes
var routes = require('../routes/index.js');

var app = express();

// routes middleware
app.use(app.router);
// serve public folder
app.use(express.static(path.join(__dirname, '../public')));

// serve index.html for every path
app.use(routes.index);

//IMPORTANT - TODO switch out these various statements when doing http vs https, and a line in socketClient
// two different servers - secure and unsecure
var server = http.createServer(app);
//var httpsServer = https.createServer(sslOptions, app);

//TODO alter these two lines to switch between http server on 8080 and https server on 8443
var io = socketio.listen(server);
//var io = socketio.listen(httpsServer);
var port = process.env.PORT || 8080;//8443;

server.listen(port, function() {
  console.log('server - listening on ' + port+ ' ' + __dirname);
});
// httpsServer.listen(port, function() {
//   console.log('httpsServer - listening on ' + port+ ' ' + __dirname);
// });

// require our chatserver
var ChatServer = require('./chatserver');

// initialize a new chat server.
//TODO also modify this (add/remove secure: true param) to switch between https and http servers
new ChatServer({io: io}).init();
