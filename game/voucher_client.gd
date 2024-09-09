extends Control
class_name VoucherClient

signal view_inputs

@onready var voucher_list:ItemList = $Events/Vouchers/ItemList
@onready var message_list:ItemList = $Events/MessageBoard/ItemList

var vouchers: Array[CartesiVoucher] = []
var messages: Array[String] = []
var messageboard_contract_address := "0x59b670e9fA9D0A427751Af201D676719a970857b" #OS.get_environment("VOUCHER_CONTRACT_TARGET")
var messageboard_abi := ["function getMessageAtIndex(uint256 index)"]
var messageboard_contract:JavaScriptObject

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Ethers.wallet_connected.connect(get_messageboard_contract)
	Ethers.wallet_connected.connect(refresh_data)
	await refresh_data()


func get_messageboard_contract():
	messageboard_contract = Ethers.get_contract(messageboard_contract_address, messageboard_abi, "messageboard")


var append_message_callback := JavaScriptBridge.create_callback(_append_message_callback)


func _append_message_callback(args):
	var msg = args[0]
	print_debug("Received message: ", msg)
	messages.append(msg)
	

func refresh_data():
	vouchers = await Cartesi.client.list_vouchers()
	var message_count = await messageboard_contract.messageCount;
	if message_count > messages.size():
		for i in range(messages.size(), message_count):
			messageboard_contract.getMessageAtIndex(i).then(append_message_callback)
	reload_vouchers()
	reload_messageboard()


func reload_vouchers():
	voucher_list.clear()
	for n in vouchers:
		voucher_list.add_item(str(n.input.index) + "-" + str(n.index) + ": \"" + n.payload + "\" to " + n.destination)


func reload_messageboard():
	message_list.clear()
	for n in messages:
		message_list.add_item(str(n))


func _on_refresh_pressed():
	await refresh_data()


func _on_execute_voucher_pressed():
	var items = voucher_list.get_selected_items()
	if items.is_empty():
		return
	else:
		Cartesi.client.execute_voucher(vouchers[items[0]])


func _on_view_inputs_pressed():
	view_inputs.emit()
