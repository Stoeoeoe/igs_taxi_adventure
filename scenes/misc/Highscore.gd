extends HTTPRequest



func post_highscore(name, score):
#	var http = HTTPClient.new()
	var dict = {"score": score, "name": name}
	var server = Settings.server_highscore_server_url
	var port = Settings.server_highscore_server_port
	var url = server + ":" + str(port) + "/highscore" 
	var body = dict.to_json()
	var result = self.request(url, [], true, HTTPClient.METHOD_POST, body)
#	var err = http.connect(server, port)
#	assert(err == OK)
#	http.request(HTTPClient.METHOD_POST, server + "/highscore", null, str(body))
	
	pass
