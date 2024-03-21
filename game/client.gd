extends Control

@onready var input_box:TextEdit = $VBox/Inputs/InputBox
@onready var voucher_list:ItemList = $Vouchers/ItemList
@onready var notice_list:ItemList = $VBox/HBox/Notices/ItemList
@onready var report_list:ItemList = $VBox/HBox/Reports/ItemList
@onready var ctsi_client:CartesiClient = CartesiClient.new()
@onready var ethers_client:Ethers = Ethers.new()

var notices: Array[CartesiNotice] = []
var reports: Array[CartesiReport] = []
var vouchers: Array[CartesiVoucher] = []
var inputs: Array[CartesiInput] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(ctsi_client)
	print_debug("Hello from Godot")
	await refresh_data()
	_on_notices_refresh_pressed()
	_on_reports_refresh_pressed()
	_on_vouchers_refresh_pressed()


func _on_send_button_pressed() -> void:
	var message = input_box.text
	print_debug("Sending message ", message)


func _on_voucher_button_pressed() -> void:
	var voucher_ids = voucher_list.get_selected_items()
	
	for v in voucher_ids:
		print_debug("Executing voucher id: ", voucher_list.get_item_text(v))

func refresh_data():
	inputs = await ctsi_client.list_inputs()
	notices = await ctsi_client.list_notices()
	reports = await ctsi_client.list_reports()
	vouchers = await ctsi_client.list_vouchers()


func _on_notices_refresh_pressed():
	notice_list.clear()
	for n in notices:
		notice_list.add_item(str(n.input.index) + "-" + str(n.index) + ": " + n.payload)


func _on_reports_refresh_pressed():
	report_list.clear()
	for n in reports:
		report_list.add_item(str(n.input.index) + "-" + str(n.index) + ": " + n.payload)


func _on_vouchers_refresh_pressed():
	voucher_list.clear()
	for n in vouchers:
		voucher_list.add_item(str(n.input.index) + "-" + str(n.index) + ": \"" + n.payload + "\" to " + n.destination)



func _on_button_pressed():
	await refresh_data()
	_on_notices_refresh_pressed()
	_on_reports_refresh_pressed()
	_on_vouchers_refresh_pressed()
