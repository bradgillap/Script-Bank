This was a Daniel Shiffman example I walked through. 

Here are some of the steps.

start with NPM

npm install express (webserver)
npm install socket.io (sockets)

write a server to receive from a client and send to the next client.

It takes the console log of drawing with p5.js position for x and y, and then sends that in the form of data over the socket created on the server.




To run on the command line run:

server.js

Then connect to localhost with two browsers on port 3000.

you should be able to draw on the canvas.