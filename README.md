# node-ios-chat-prototype
Sample application to prototype communicating using a Swift iOS app through sockets to a Node.js server, with accompanying web app.

Uses the following tools:
* Node.js - server
* Express.js - supplements Node.js
* Backbone.js - structure for client-side code
* Underscore.js - for basic templating
* Socket.io - for realtime communication
* openssl - for secure server :  no longer used, opted for initial server to be insecure for simplicity and since it's only run locally

Server and web app based on this sample: https://github.com/eguneys/chat-socketio

The iOS component is built in Swift and communicates using the socket.io swift component: https://github.com/socketio/socket.io-client-swift

To run the web application:

1. Clone the repo locally and cd to the folder
2. Run `npm install`
Either run `npm start` or manually cd to /scripts and run `node web.js`
3. Open localhost:8080 to view

To run the iOS app/communicate with the web app:

1. Import the iOS project portion into XCode
2. Make sure the server has already been started (from the section above)
3. Run on an iPad simulator
