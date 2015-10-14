$(document).ready(function() {
  var mainController = new MainController();
  mainController.init();
});

var MainController = function() {
  var self = this;

  // Event Bus for socket client
  self.appEventBus = _.extend({}, Backbone.Events);
  // Event Bus for Backbone Views
  self.viewEventBus = _.extend({}, Backbone.Events);

  // initialize function
  self.init = function() {
    // create a chat client and connect
    self.chatClient = new ChatClient({vent: self.appEventBus});
    self.chatClient.connect();

    // create our views, place login view inside container first.
    self.loginModel = new LoginModel();
    self.containerModel = new ContainerModel({
      viewState: new LoginView({
        vent: self.viewEventBus,
        model: self.loginModel
      })
    });
    self.containerView = new ContainerView({model: self.containerModel});
    self.containerView.render();
  };

  // View Event Bus Message Handlers
  self.viewEventBus.on('login', function(name) {
    // socketio login
    self.chatClient.login(name);
  });

  self.viewEventBus.on('chat', function(chat) {
    // socketio chat
    self.chatClient.chat(chat);
  });

  // Socket Client Event Bus Message Handlers

  // triggered when login success
  self.appEventBus.on('loginDone', function() {
    self.homeModel = new HomeModel();
    self.homeView  = new HomeView({vent: self.viewEventBus, model: self.homeModel});

    // set viewstate to homeview
    self.containerModel.set('viewState', self.homeView);
  });

  // triggered when login error due to bad name
  self.appEventBus.on('loginNameBad', function(name) {
    self.loginModel.set('error', 'Invalid Name');
  });

  // triggered when login error due to already existing name
  self.appEventBus.on('loginNameExists', function(name) {
    self.loginModel.set('error', 'Name already exists');
  });

  // triggered when client requests users info
  // responds with an array of online users.
  self.appEventBus.on('usersInfo', function(data) {
    var onlineUsers = self.homeModel.get('onlineUsers');
    var users = _.map(data, function(item) {
      return new UserModel({name: item});
    });

    onlineUsers.reset(users);
  });

  // triggered when a client joins the server
  self.appEventBus.on('userJoined', function(username) {
    self.homeModel.addUser(username);
    self.homeModel.addChat({sender: '', message: username + ' joined room.'});
  });

  // triggered when a client leaves the server
  self.appEventBus.on('userLeft', function(username) {
    self.homeModel.removeUser(username);
    self.homeModel.addChat({sender: '', message: username + ' left room.'});
  });

  // triggered when chat receieved
  self.appEventBus.on('chatReceived', function(chat) {
    self.homeModel.addChat(chat);
  });
}
