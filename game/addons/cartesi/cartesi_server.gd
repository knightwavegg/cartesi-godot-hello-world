extends Node

var ROLLUP_SERVER = OS.get_environment("ROLLUP_HTTP_SERVER_URL")

var request_args = {
	url = ROLLUP_SERVER + "/finish",
	headers = PackedStringArray(["content-type: application/json"]),
	method = HTTPClient.METHOD_POST,
	request_data = JSON.stringify({
		status = "accept"
	})
}

var event_queue:Array[CartesiEvent] = []

signal advance_state_request_received(String)
signal inspect_state_request_received(String)
signal event_queue_flushed

var handling_request = false


func query_state():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._finish_query_completed)

	# Perform the HTTP request. The URL below returns a PNG image as of writing.
	var error = http_request.request(
		request_args.url,
		request_args.headers,
		request_args.method,
		request_args.request_data
	)

	if error != OK:
		print("An error occurred in the HTTP request.")


# Called when the HTTP request is completed.
func _finish_query_completed(result, response_code, headers, body:PackedByteArray):
	print_debug("finish query completed")
	if result != HTTPRequest.RESULT_SUCCESS:
		print("Error requesting rollup server")
	
	if response_code == 202 || body.is_empty():
		print_debug("No requests received, will query again")
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
	var event = CartesiEvent.new(ROLLUP_SERVER + "/notice", request_args.headers, request_args.method, { payload= encode_hex(payload) })
	event_queue.push_back(event)


func publish_report(payload):
	var event = CartesiEvent.new(ROLLUP_SERVER + "/report", request_args.headers, request_args.method, { payload= encode_hex(payload) } )
	event_queue.push_back(event)


func publish_voucher(destination, payload):
	var event = CartesiEvent.new(ROLLUP_SERVER + "/voucher", request_args.headers, request_args.method, {
			destination = "0x66c17Dcef1B364014573Ae0F869ad1c05fe01c89",
			payload = encode_hex(payload)
		} )
	event_queue.push_back(event)


func flush():
	print_debug("Flushing event queue")
	while !event_queue.is_empty():
		var event := event_queue.pop_front()
		add_child(event)
		event.execute_request()
		await event.complete
	event_queue_flushed.emit()


func decode_hex(data: String) -> String:
	if data.begins_with("0x"):
		data = data.substr(2)
	return data.hex_decode().get_string_from_utf8()


func encode_hex(data: String) -> String:
	return "0x" + data.to_utf8_buffer().hex_encode()
