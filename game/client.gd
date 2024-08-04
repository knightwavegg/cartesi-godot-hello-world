extends Control

var INPUT_BOX_CONTRACT_ADDRESS = "0x0"#Config.get("input_box_contract_address")
var DAPP_CONTRACT_ADDRESS = "0x0"#Config.get("dapp_contract_address")


@onready var input_client:Control = $InputClient
@onready var voucher_client:Control = $VoucherClient

@onready var input_box:TextEdit = $InputClient/Input/MessageBox
@onready var notice_list:ItemList = $InputClient/Events/Notices/ItemList
@onready var report_list:ItemList = $InputClient/Events/Reports/ItemList

@onready var voucher_list:ItemList = $VoucherClient/Events/Vouchers/ItemList

@onready var ctsi_client:CartesiClient = CartesiClient.new(INPUT_BOX_CONTRACT_ADDRESS, DAPP_CONTRACT_ADDRESS)

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

func _on_go_to_vouchers():
	input_client.visible = false
	voucher_client.visible = true

func _on_go_to_inputs():
	voucher_client.visible = false
	input_client.visible = true


func _on_connect_wallet_pressed() -> void:
	print_debug("Connecting wallet")
	ctsi_client.connect_wallet()


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


func _on_send_input_pressed():
	ctsi_client.send_input(input_box.text)


func _on_refresh_pressed():
	await refresh_data()
	_on_notices_refresh_pressed()
	_on_reports_refresh_pressed()
	_on_vouchers_refresh_pressed()


func _on_execute_voucher_pressed():
	var items = voucher_list.get_selected_items()
	if items.is_empty():
		return
	else:
		ctsi_client.execute_voucher(vouchers[items[0]])
		
