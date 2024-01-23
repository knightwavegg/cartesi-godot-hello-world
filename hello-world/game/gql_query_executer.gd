extends Node

class_name GQLQueryExecuter

signal graphql_response(Dictionary)

var endpoint: String
var query: String
var use_ssl: bool
var query_cached: String = ""

var headers = ["Content-Type: application/json"]
var request : HTTPRequest


func _init(_endpoint:String, _use_ssl: bool, _query: String):
	endpoint = _endpoint
	query = _query
	use_ssl = _use_ssl


func _ready():
	request = HTTPRequest.new()
	request.request_completed.connect(self.request_completed)
	add_child(request)


func request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	print("Request completed:", result, ",",  response_code)
	if response_code!=200:
		print("Query:"+query_cached)
		print("Response:"+body.get_string_from_utf8())
	var json := JSON.new()
	json.parse(body.get_string_from_utf8())
	graphql_response.emit(json.data)


func run(variables: Dictionary = {}):
	assert(request!=null, 'You should add this node to the childs')
	var data_to_send = {
		"query": query
	}
	if variables != {}:
		data_to_send["variables"] = variables
	var body = JSON.new().stringify(data_to_send)
	var err=request.request(endpoint, headers, HTTPClient.METHOD_POST, body)
