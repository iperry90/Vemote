//http://api.espn.com/:version/:resource/:method?apikey=:yourkey
var gapi = require('googleapis');
var fs = require('fs'); 
var XMLHttpRequest = require("xmlhttprequest").XMLHttpRequest;
var xhr = new XMLHttpRequest();
gapi.discover('youtube', 'v3');
var port = 4000;
var app = require('http').createServer(handler);
var io = require('socket.io').listen(app);

console.log("Listening on port " + port);
app.listen(port);


function handler (req, res) {
	fs.readFile(__dirname + '/index.html',
			function (err, data) {
			if (err) {
			res.writeHead(500);
			return res.end('Error loading index.html');
			}

			res.writeHead(200);
			res.end(data);
			});
}



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
///			case "insta": 
///				console.log("insta data hereeeee : " + JSON.stringify(data));  
///				xhr.open("GET", "https://api.instagram.com/v1/users/self/feed?access_token=" + data.access_token);
//				xhr.send();
//				feed = xhr.responseXML;
//				console.log("this is response code "  +  xhr.status);	 //get user feed
//				io.sockets.emit('newsfeed', feed); 
//		 
//			break;
 //			case "play_music":
//				console.log(JSON.parse(data)); 

			
//			break; 
//			case "fullscreen": 
//				io.sockets.emit('fullscreen');
//
//			break; 
			
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






