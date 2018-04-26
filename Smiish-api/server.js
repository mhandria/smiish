'use strict';

var express = require('express');
var app = express();
// var app = require('express')();
var path = require('path');
var http = require('http').Server(app);
var io = require('socket.io')(http);
var port = process.env.PORT || 3000;


//Initialize variables
var connected = false;
var numUsers;

// app.get('/', function(req, res){
//   res.send("{msg: this is the api endpoint for SMIISH}")
// });

// Routing
app.use(express.static(path.join(__dirname)));


http.listen(port, function(){
  console.log("congrats you got the server running @ port:3000");
})

//When user connects to server
io.on('connection', function(socket){
  console.log("user connected");
  var addedUser = false;
  var numUsers = 0;

  //When the client emits 'login', this listens and executes
  socket.on('login', function(data){
    if (addedUser) return;
    //Store username and roomName in the socket session for
    //this client
    addedUser = true;
    socket.username = data.username;
    socket.roomName = data.roomName;
    //User joins room and echoes to room that user joined
    //Provide client with username
    socket.join(socket.roomName);
    //Get number of users in room
    var room = io.sockets.adapter.rooms[socket.roomName];
    socket.numUsers = room.length;
    io.of('/').in(socket.roomName).clients((error, clients) => {
      if (error) throw error;

      // Returns an array of client IDs like ["Anw2LatarvGVVXEIAAAD"]
        console.log(clients);
      });
    socket.emit('user join', {
      username: socket.username,
      roomName: socket.roomName,
      numUsers: socket.numUsers
    });
    socket.broadcast.to(socket.roomName).emit('new user', {
      username: socket.username,
      numUsers: socket.numUsers
    });
  });

  //When the client emits 'chat message', this listens and executes
  socket.on('chat message', function(message){
    //Echo to 'room name' the message
    //Provide client username and message
    socket.broadcast.to(socket.roomName).emit('chat message', {
      username: socket.username,
      message: message
    });
  });

  //When the client emits 'disconnected', this listens and executes
  socket.on('disconnect', function(){
    //Disconnect user socket from the room channel
    socket.leave(socket.roomName);
    console.log('user disconnected');
    //Update number of users in room
    var room = io.sockets.adapter.rooms[socket.roomName];
    if (room != undefined){
      socket.numUsers = room.length;
      //Echo to room that this client has left
      //Provide username to client
      socket.broadcast.to(socket.roomName).emit('user left', {
        username: socket.username,
        numUsers: socket.numUsers
      });
    }
  });
});
