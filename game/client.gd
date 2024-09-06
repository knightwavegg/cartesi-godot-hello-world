extends Control

@onready var explorer_client:ExplorerClient = get_node("ExplorerClient")
@onready var voucher_client:VoucherClient = get_node("VoucherClient")

func _ready() -> void:
	print_debug("Hello from Godot")
	explorer_client.view_vouchers.connect(_on_go_to_vouchers)
	voucher_client.view_inputs.connect(_on_go_to_inputs)
	_on_go_to_inputs()


func _on_go_to_vouchers():
	explorer_client.visible = false
	voucher_client.visible = true


func _on_go_to_inputs():
	voucher_client.visible = false
	explorer_client.visible = true
