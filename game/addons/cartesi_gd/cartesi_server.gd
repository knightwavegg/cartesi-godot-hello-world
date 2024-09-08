class_name CartesiServer
extends Node

var ROLLUP_SERVER = OS.get_environment("ROLLUP_HTTP_SERVER_URL")

var request_args = {
	url = ROLLUP_SERVER + "/finish",
	headers = PackedStringArray(["content-type: application/json"]),
	method = HTTPClient.METHOD_POST,
	request_data = JSON.stringify({
		status="accept"
	})
}

var event_queue: Array[CartesiEvent] = []

signal advance_state_request_received(String)
signal inspect_state_request_received(String)
signal event_queue_flushed

var handling_request = false


func query_state():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._finish_query_completed)

	var error = http_request.request(
		request_args.url,
		request_args.headers,
		request_args.method,
		request_args.request_data
	)

	if error != OK:
		print("An error occurred in the HTTP request.")


# Called when the finish HTTP request is completed.
func _finish_query_completed(result, response_code, headers, body: PackedByteArray):
	print_debug("finish query completed")
	if result != HTTPRequest.RESULT_SUCCESS:
		print("Error requesting rollup server")
	
	if response_code == 202||body.is_empty():
		print_debug("No requests received, will query again")
		query_state()
	else:
		var response_raw = body.get_string_from_utf8()
		print("Parsing JSON response: ", response_raw)
		var response = JSON.parse_string(response_raw)
		var payload = Cartesi.decode_hex(response["data"]["payload"])
		# TODO: Convert response payload from hex to string
		if response["request_type"] == "advance_state":
			print("Advance request: ", response)
			advance_state_request_received.emit(payload)
		elif response["request_type"] == "inspect_state":
			print("Inspect request: ", response)
			inspect_state_request_received.emit(payload)


func publish_notice(payload):
	var event = CartesiEvent.new(ROLLUP_SERVER + "/notice", request_args.headers, request_args.method, {payload=Cartesi.encode_hex(payload)})
	event_queue.push_back(event)


func publish_report(payload):
	var event = CartesiEvent.new(ROLLUP_SERVER + "/report", request_args.headers, request_args.method, {payload=Cartesi.encode_hex(payload)})
	event_queue.push_back(event)


func publish_voucher(destination:String, function_abi:String, transaction_args:Array):
	var cast_args = PackedStringArray(["calldata", function_abi])
	cast_args.append("".join(PackedStringArray(transaction_args)))
	
	var cast_output = []
	var exit_code = OS.execute("cast", cast_args, cast_output, true)
	print_debug("Exit code: ", exit_code)
	print_debug("Cast output: ", cast_output)

	var event = CartesiEvent.new(ROLLUP_SERVER + "/voucher", request_args.headers, request_args.method, {
			destination=destination,
			payload=cast_output[0].trim_suffix("\n")
		})

	event_queue.push_back(event)


func flush():
	print_debug("Flushing event queue")
	while !event_queue.is_empty():
		var event := event_queue.pop_front()
		add_child(event)
		event.execute_request()
		await event.complete
	event_queue_flushed.emit()
