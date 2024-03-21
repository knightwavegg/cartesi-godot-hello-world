extends Node

var VOUCHER_CONTRACT_TARGET = "0x0"

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Hello from Godot on Cartesi")
	Cartesi.advance_state_request_received.connect(handle_advance)
	Cartesi.inspect_state_request_received.connect(handle_inspect)
	Cartesi.event_queue_flushed.connect(Cartesi.query_state)
	Cartesi.query_state()


func handle_advance(payload) -> void:
	Cartesi.publish_notice(payload)
	Cartesi.publish_report(payload)
	Cartesi.publish_voucher(VOUCHER_CONTRACT_TARGET, payload)
	Cartesi.flush()


func handle_inspect(payload) -> void:
	pass
