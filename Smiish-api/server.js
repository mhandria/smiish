'use strict';

var express = require('express');
var app = express();

var path = require('path');
var http = require('http').Server(app);
var io = require('socket.io')(http);
var port = process.env.PORT || 3000;
var cors = require('cors');

const allowed = ['http://localhost:3000', 'https://smiish.com'];

const corsOptions = {
  origin: allowed,
  preflightContinue: true,
  allowedHeaders: 'Content-Type,Authorization',
  methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
};


// Enable the cors options on all routes
app.use(cors(corsOptions));
app.options('*', cors(corsOptions));
app.use(express.static(__dirname));


http.listen(port, function(){
  console.log("Smiish Running on port:3000");
})

//When user connects to server
io.on('connection', function(socket){
  console.log("user connected");
  var addedUser = false;

  //TODO: DEPRECATE
  //When the client emits 'login', this listens and executes
  socket.on('login', function(data){


    if(!addedUser){
      //Store username and roomName in socket session
      socket.username = data.username;
      socket.roomName = data.roomName;
      addedUser = true;
    }

    //User joins roomName
    socket.join(socket.roomName);

    //Get number of users in room and store in socket session
    var room = io.sockets.adapter.rooms[socket.roomName];
    socket.numUsers = room.length;

    //Emit to new user on front end roomName and numUsers
    socket.emit('user join', {
      roomName: socket.roomName,
      numUsers: socket.numUsers
    });

    //Emit to all clients in room new username and updated numUsers
    socket.broadcast.to(socket.roomName).emit('new user', {
      username: socket.username,
      numUsers: socket.numUsers
    });

    // //Will use later to obtain username from socket.id input for hash
    // io.in(socket.roomName).clients((error, clients) => {
    //   if (error) throw error;
    //
    //   // Returns an array of client IDs like ["Anw2LatarvGVVXEIAAAD"]
    //   console.log(clients);
    // });
  });

  /*
    When the client emits 'clients in room', this listens and executes
    This emits to every client in the room to get a response to determine
    who's in the room.
  */
  socket.on('clients in room', function(){
    // sending to all clients in 'roomName', including sender
    io.in(socket.roomName).emit('get clients');
  });

  /*
    When the client emits 'present', this listens and executes
    This will forward the responses from each client in room to all clients
    in room.
  */
  socket.on('present', function(data){
    // sending to all clients in 'roomName' room, including sender
    io.in(socket.roomName).emit('client response', {
      username: data.username
    });
  });

  /*
    When the client emits 'chat message', this listens and executes
  */
  socket.on('chat message', function(message){

    //Get system time in milliseconds
    var ts = Math.round((new Date()).getTime());

    // Create a new JavaScript Date object based on the timestamp
    var date = new Date(ts);

    // Get Hours, Miutes, and Seconds parts from the timestamp
    var hours = date.getHours();
    var minutes = "0" + date.getMinutes();
    var seconds = "0" + date.getSeconds();

    // Will display time in 10:30:23 format
    var formattedTime = hours + ':' + minutes.substr(-2) + ':' + seconds.substr(-2);
    //Echo to 'room name' the message
    //Provide client username and message
    socket.broadcast.to(socket.roomName).emit('chat message', {
      username: socket.username,
      systemTime: formattedTime,
      message: message
    });
  });

  /*
    When the client emits 'disconnected', this listens and executes
  */
  socket.on('disconnect', function(){
    //Disconnect user socket from the room channel
    socket.leave(socket.roomName);
    console.log('user disconnected');
    //Update number of users in room
    var room = io.sockets.adapter.rooms[socket.roomName];
    if (room != undefined){
      //Echo to room that this client has left
      //Provide username to client and updated numUsers
      socket.broadcast.to(socket.roomName).emit('user left', {
        username: socket.username,
        numUsers: room.length
      });
    }
    // Update clientList
    // sending to all clients in 'roomName', including sender
    io.in(socket.roomName).emit('get clients');
  });
});
