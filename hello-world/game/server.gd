extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Hello from Godot on Cartesi")
	Cartesi.query_state()
	Cartesi.advance_state_request_received.connect(handle_advance)
	Cartesi.inspect_state_request_received.connect(handle_inspect)


func handle_advance(payload) -> void:
	Cartesi.publish_notice(payload)
	Cartesi.publish_report(payload)
	Cartesi.publish_voucher("0x0", payload)
	#Cartesi.handle_advance(payload)


func handle_inspect(payload) -> void:
	pass
	#Cartesi.handle_inspect(payload)
