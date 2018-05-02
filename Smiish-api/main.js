'use strict';

$(function() {
  var FADE_TIME = 150; // ms
  var TYPING_TIMER_LENGTH = 400; // ms
  var COLORS = [
    '#e21400', '#91580f', '#f8a700', '#f78b00',
    '#58dc00', '#287b00', '#a8f07a', '#4ae8c4',
    '#3b88eb', '#3824aa', '#a700ff', '#d300e7'
  ];

  // Initialize variables
  var $window = $(window);
  var $usernameInput = $('.usernameInput'); // Input for username
  var $roomNameInput = $('.roomNameInput'); // Input for room name
  var $messages = $('.messages'); // Messages area
  var $inputMessage = $('.inputMessage'); // Input message input box

  var $loginPage = $('.login.page'); // The login page
  var $chatPage = $('.chat.page'); // The chatroom page

  // Prompt for setting a username
  var username;
  var roomName;
  var connected = false;
  var $currentInput = $usernameInput.focus();
  var clientList = [];
  var socket = io();


  // FUNCTIONS

  function addParticipantsMessage (data) {
    var message = '';
    if (data.numUsers === 1) {
      message += "there's 1 participant";
    } else {
      message += "there are " + data.numUsers + " participants";
    }
    log(message);
  }

  // Sends a chat message
  function sendMessage () {
    var message = $inputMessage.val();
    // Prevent markup from being injected into the message
    message = cleanInput(message);

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

    // if there is a non-empty message and a socket connection
    if (message && connected) {
      $inputMessage.val('');
      addChatMessage({
        username: username,
        systemTime: formattedTime,
        message: message
      });
      // tell server to execute 'new message' and send along one parameter
      socket.emit('chat message', message);
    }
  }

  // Log a message
  function log (message, options) {
    var $el = $('<li>').addClass('log').text(message);
    addMessageElement($el, options);
  }

  // Adds the visual chat message to the message list
  function addChatMessage (data, options) {
    // Don't fade the message in if there is an 'X was typing'
    // var $typingMessages = getTypingMessages(data);
    options = options || {};
    // if ($typingMessages.length !== 0) {
    //   options.fade = false;
    //   $typingMessages.remove();
    // }
    var $usernameDiv = $('<span class="username"/>')
      .text(data.systemTime + " " + data.username)
      .css('color', getUsernameColor(data.username));
    var $messageBodyDiv = $('<span class="messageBody">')
      .text(data.message);

    // var typingClass = data.typing ? 'typing' : '';
    var $messageDiv = $('<li class="message"/>')
      .data('username', data.username)
      // .addClass(typingClass)
      .append($usernameDiv, $messageBodyDiv);

    addMessageElement($messageDiv, options);
  }

  // Adds a message element to the messages and scrolls to the bottom
  // el - The element to add as a message
  // options.fade - If the element should fade-in (default = true)
  // options.prepend - If the element should prepend
  //   all other messages (default = false)
  function addMessageElement (el, options) {
    var $el = $(el);

    // Setup default options
    if (!options) {
      options = {};
    }
    if (typeof options.fade === 'undefined') {
      options.fade = true;
    }
    if (typeof options.prepend === 'undefined') {
      options.prepend = false;
    }

    // Apply options
    if (options.fade) {
      $el.hide().fadeIn(FADE_TIME);
    }
    if (options.prepend) {
      $messages.prepend($el);
    } else {
      $messages.append($el);
    }
    $messages[0].scrollTop = $messages[0].scrollHeight;
  }

  // Gets the color of a username through our hash function
  function getUsernameColor (username) {
    // Compute hash code
    var hash = 7;
    for (var i = 0; i < username.length; i++) {
       hash = username.charCodeAt(i) + (hash << 5) - hash;
    }
    // Calculate color
    var index = Math.abs(hash % COLORS.length);
    return COLORS[index];
  }

  // Sets the client's username
  function setUsername () {
    username = cleanInput($usernameInput.val().trim());

    // If the username is valid
    if (username) {
      // console.log("username valid")
      $currentInput = $roomNameInput.focus();
    };
  };

  // Sets the client's room name
  function setRoomName () {
    roomName = cleanInput($roomNameInput.val().trim());

    // If the rome name is valid
    if (roomName) {
      // console.log("room name valid")
      $loginPage.fadeOut();
      $chatPage.show();
      $loginPage.off('click');
      $currentInput = $inputMessage.focus();

      socket.emit('login', {
        username: username,
        roomName: roomName
      });
    };
  };

  // Click events

  // Focus input when clicking anywhere on login page
  $loginPage.click(function () {
    $currentInput.focus();
  });

  // Keyboard events

  $window.keydown(function (event) {
    // Auto-focus the current input when a key is typed
    if (!(event.ctrlKey || event.metaKey || event.altKey)) {
      $currentInput.focus();
    }
    // When the client hits ENTER on their keyboard
    if (event.which === 13) {
      // console.log("enter pressed");
      if (username && roomName) {
        // console.log("username and room name valid");
        // Tell the server your username and room name
        sendMessage();
      } else if (username && !roomName) {
        // console.log("room name invalid");
        setRoomName();
      } else if (!username && roomName) {
        // console.log("username invalid");
        setUsername();
      } else {
        // console.log("username invalid");
        setUsername();
      }
    };
  });

  // Prevents input from having injected markup
  function cleanInput (input) {
    return $('<div/>').text(input).html();
  }

  //Debug purposes
  function addUser(username){
    console.log(username);
    clientList.push(username);
    console.log(clientList);
  };

  //CLIENTS LISTENING FROM SERVER

  //Whenever the server emits 'login' this listens and executes
  socket.on('user join', function(data){
    connected = true;
    console.log(data);
    // Display the welcome message
    var message = "Welcome to " + data.roomName;
    log(message, {
      prepend: true
    });
    addParticipantsMessage(data);

    //Emit to server to get list of all clients in same room
    socket.emit('clients in room');
  });

  //Whenver the server emits 'get clients', this listens and executes
  //Clients will emit 'present' to confirm presence in room
  socket.on('get clients', function(){
    //clear clientList for each client
    clientList = [];

    socket.emit('present', {
      username: username
    });
  });

  //Whenever the server emits 'client response', this listens and executes
  //Each client will append all clients in room
  socket.on('client response', function(data){
    //add other clients to new user clientList
    // clientList.push(data.username);
    addUser(data.username);
  });

  //Whenever the server emits 'user joined', log it in the header
  socket.on('new user', function(data) {
    log(data.username + ' joined');
    addParticipantsMessage(data);
  });

  //Whenever the server emits 'chat message', this listens and executes
  socket.on('chat message', function(data){
    addChatMessage(data);
  });

  // Whenever the server emits 'user left', log it in the chat body
  socket.on('user left', function(data) {
    log(data.username + ' left');
    addParticipantsMessage(data);
    // removeChatTyping(data);
  });

  socket.on('disconnect', function () {
    log('you have been disconnected');
  });
});
