extends Control
class_name VoucherClient

signal view_inputs

@onready var voucher_list:ItemList = $Events/Vouchers/ItemList

var vouchers: Array[CartesiVoucher] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await refresh_data()
	_on_vouchers_refresh_pressed()


func refresh_data():
	vouchers = await Cartesi.client.list_vouchers()


func _on_vouchers_refresh_pressed():
	voucher_list.clear()
	for n in vouchers:
		voucher_list.add_item(str(n.input.index) + "-" + str(n.index) + ": \"" + n.payload + "\" to " + n.destination)


func _on_refresh_pressed():
	await refresh_data()
	_on_vouchers_refresh_pressed()


func _on_execute_voucher_pressed():
	var items = voucher_list.get_selected_items()
	if items.is_empty():
		return
	else:
		Cartesi.client.execute_voucher(vouchers[items[0]])
		


func _on_view_inputs_pressed():
	view_inputs.emit()
