///http://api.espn.com/:version/:resource/:method?apikey=:yourkey
//api stuff goes up here 
var gapi = require('googleapis');
var XMLHttpRequest = require("xmlhttprequest").XMLHttpRequest;
var xhr = new XMLHttpRequest();
gapi.discover('youtube', 'v3');

var express = require('express'),
 	app = express(),
	server = require('http').createServer(app),
	port = 4000;


var io = require('socket.io').listen(server);

console.log("Listening on port " + port);
server.listen(port);

app.get('/', function(req, res){
  res.sendfile(__dirname + '/views/index.html');
});




io.sockets.on('connection', function (socket) {
		socket.emit('log', {foo:'hello'});
		// when the client emits 'sendchat', this listens and executes
		var feed; 
		socket.on('message', function (data) {
			console.log("this is the data object we are returning " + data); 	
			switch (data.intent) {
			case "play_youtube": 
				ysearch(data.query);
			break;
			case "stop": 
				io.sockets.emit('pause');	
			break;
			case "resume": 
				io.sockets.emit('resume');
			break;			
			default: -1;			 	
			}	
			});
		socket.on('disconnect', function(){
			});

		function ysearch(q) {
			console.log('i am in fucniton!'); 
			//var q = ('hello');
			gapi.execute(function(err, client){
					var req = client.youtube.search.list({
					q: q,
					part: 'snippet',
					key: 'AIzaSyDqj127qEB6Jt7-fzoZwUxC1YnU0aURKgQ'
					})
					req.execute(function(err, response) {
						io.sockets.emit('update', response.items[0].id.videoId); 
					})
			})
		}




});






