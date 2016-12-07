var socket;

function setup() {
	//connect the client to the server.
	socket = io.connect('http://localhost:3000');
	createCanvas(600, 400);
	background(51);
	socket.on('mouse', newDrawing);
}

function newDrawing(data) {
	
	noStroke();
	fill(255,0,100);
	ellipse(data.x, data.y, 36, 36);
	
}

function mouseDragged() {
	console.log(mouseX + ',' + mouseY); //log position to console
	console.log('Sending: ' + mouseX + '', + mouseY); 
	var data = {
		x: mouseX,
		y: mouseY
	}
	
	socket.emit('mouse', data); //attach the data to the emitter
	
	
	noStroke();
	fill(255);
	ellipse(mouseX, mouseY, 36, 36);
}

function draw() {
	
	
}