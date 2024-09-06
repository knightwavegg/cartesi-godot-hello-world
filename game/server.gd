extends Node

var dapp_abi = "function addMessage(string calldata message)"
var VOUCHER_CONTRACT_TARGET = OS.get_environment("VOUCHER_CONTRACT_TARGET")
# Called when the node enters the scene tree for the first time.
func _ready():
	print("Hello from Godot on Cartesi")
	# TODO: Add handling of advance request types to enable bootstrapping/config changes externally
	Cartesi.server.advance_state_request_received.connect(handle_advance)
	Cartesi.server.inspect_state_request_received.connect(handle_inspect)
	Cartesi.server.event_queue_flushed.connect(Cartesi.server.query_state)
	Cartesi.server.query_state()


func handle_advance(payload) -> void:
	Cartesi.server.publish_notice(payload)
	Cartesi.server.publish_report(payload)
	Cartesi.server.publish_voucher(VOUCHER_CONTRACT_TARGET, dapp_abi, payload)
	Cartesi.server.flush()


func handle_inspect(payload) -> void:
	pass
