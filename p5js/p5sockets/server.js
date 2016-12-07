//require the library for the quick webserver npm install express --save
var express = require('express');

//Create the app by importing the express function and running the function on port 3000.
var app = express();
var server = app.listen(3000);

//host webserver files in a www directory
app.use(express.static('www'));

//import the socket library. on npm it npm install socket.io --save
var socket = require('socket.io');

//call socket function and give it the server as an argument.
var io = socket(server);

// new connection event function
io.sockets.on('connection', newConnection);

function newConnection(socket) {
	console.log('New Connection: ' + socket.id);
	
	socket.on('mouse', mouseMsg);
	
	function mouseMsg(data) {
		socket.broadcast.emit('mouse', data);
		// io.sockets.emit ('mouse', data);  Would send from server to both clients.
		console.log(data);

	}
	
}

console.log("My socket is server is running");