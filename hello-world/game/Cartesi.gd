extends Node

var rollup_server = OS.get_environment("ROLLUP_HTTP_SERVER_URL")
# Called when the node enters the scene tree for the first time.

var request_args = {
	url = rollup_server + "/finish",
	custom_headers = PackedStringArray(["content-type: application/json"]),
	method = HTTPClient.METHOD_POST,
	request_data = JSON.stringify({
		status = "accept"
	})
}

signal advance_state_request_received(String)
signal inspect_state_request_received(String)


func query_state():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._finish_query_completed)

	# Perform the HTTP request. The URL below returns a PNG image as of writing.
	var error = http_request.request(
		request_args.url,
		request_args.custom_headers,
		request_args.method,
		request_args.request_data
	)

	if error != OK:
		print("An error occurred in the HTTP request.")


# Called when the HTTP request is completed.
func _finish_query_completed(result, response_code, headers, body:PackedByteArray):
	if result != HTTPRequest.RESULT_SUCCESS:
		print("Error requesting rollup server")
	
	if response_code == 202 || body.is_empty():
		query_state()
	else:
		var response_raw = body.get_string_from_utf8()
		print("Parsing JSON response: ", response_raw)
		var response = JSON.parse_string(response_raw)
		var payload = decode_hex(response["data"]["payload"])
		# TODO: Convert response payload from hex to string
		if response["request_type"] == "advance_state":
			print("Advance request: ", response)
			advance_state_request_received.emit(payload)
		elif response["request_type"] == "inspect_state":
			print("Inspect request: ", response)
			inspect_state_request_received.emit(payload)


func publish_notice(payload):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._cartesi_request_completed)
	print(payload)
	var args = {
		url = rollup_server + "/notice",
		header = request_args.custom_headers,
		method = request_args.method,
		request_data = JSON.stringify({
			payload = encode_hex(payload)
		})
	}
	print("Sending notice: ", args)
	var error = http_request.request(
		args.url,
		args.header,
		args.method,
		args.request_data
	)


func publish_report(payload):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._cartesi_request_completed)
	print(payload)
	var args = {
		url = rollup_server + "/report",
		header = request_args.custom_headers,
		method = request_args.method,
		request_data = JSON.stringify({
			payload = encode_hex(payload)
		})
	}
	print("Sending report: ", args)
	var error = http_request.request(
		args.url,
		args.header,
		args.method,
		args.request_data
	)


func publish_voucher(destination, payload):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._cartesi_request_completed)
	print(payload)
	var args = {
		url = rollup_server + "/voucher",
		header = request_args.custom_headers,
		method = request_args.method,
		request_data = JSON.stringify({
			destination = "0x66c17Dcef1B364014573Ae0F869ad1c05fe01c89",
			payload = encode_hex(payload)
		})
	}
	print("Sending voucher: ", args)
	var error = http_request.request(
		args.url,
		args.header,
		args.method,
		args.request_data
	)


func _cartesi_request_completed(result, response_code, headers, body:PackedByteArray):
	print("Request completed: ", body.get_string_from_utf8())
	query_state()


#
# Client Methods
#

# Send an Advance request to 
func advance(data):
	# TODO Wrap Blockchain API instead
	print("Payload: ", data)
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)

	# Perform the HTTP request. The URL below returns a PNG image as of writing.
	var error = http_request.request(
		rollup_server + "/advance",
		request_args.custom_headers,
		request_args.method,
		JSON.stringify({
			payload = encode_hex(data)
		})
	)


func inspect(data):
	print_debug(data)
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)

	# Perform the HTTP request. The URL below returns a PNG image as of writing.
	var error = http_request.request(
		rollup_server + "/inspect",
		request_args.custom_headers,
		request_args.method,
		JSON.stringify({
			payload = encode_hex(data)
		})
	)


func _http_request_completed(result, response_code, headers, body:PackedByteArray):
	print("Request completed: ", body)


func decode_hex(data: String) -> String:
	if data.begins_with("0x"):
		data = data.substr(2)
	return data.hex_decode().get_string_from_utf8()


func encode_hex(data: String) -> String:
	return "0x" + data.to_utf8_buffer().hex_encode()
