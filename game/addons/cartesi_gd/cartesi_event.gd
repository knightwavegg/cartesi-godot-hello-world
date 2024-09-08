extends Node
class_name CartesiEvent

signal complete
var url:String
var headers:PackedStringArray
var method := HTTPClient.METHOD_POST
var request_data:Dictionary

func _init(url:String, headers:PackedStringArray, method:int, request_data:Dictionary):
	self.url = url
	self.headers = headers
	self.method = method
	self.request_data = request_data


func execute_request():
	print_debug("Sending request to ", url, " with data ", JSON.stringify(request_data))
	var http_request = HTTPRequest.new()
	http_request.request_completed.connect(_request_completed)
	add_child(http_request)
	var error = http_request.request(
		url,
		headers,
		method,
		JSON.stringify(request_data)
	)

func _request_completed(result, response_code, headers, body:PackedByteArray):
	print("Request completed: ", body.get_string_from_utf8())
	complete.emit()
