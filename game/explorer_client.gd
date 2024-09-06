extends Control
class_name ExplorerClient

signal view_vouchers

@onready var input_box:TextEdit = $Input/MessageBox
@onready var notice_list:ItemList = $Events/Notices/ItemList
@onready var report_list:ItemList = $Events/Reports/ItemList

var notices: Array[CartesiNotice] = []
var reports: Array[CartesiReport] = []
var inputs: Array[CartesiInput] = []


func _ready() -> void:
	print_debug("Hello from Godot")
	await refresh_data()
	_on_notices_refresh_pressed()
	_on_reports_refresh_pressed()


func refresh_data():
	inputs = await Cartesi.client.list_inputs()
	notices = await Cartesi.client.list_notices()
	reports = await Cartesi.client.list_reports()


func _on_notices_refresh_pressed():
	notice_list.clear()
	for n in notices:
		notice_list.add_item(str(n.input.index) + "-" + str(n.index) + ": " + n.payload)


func _on_reports_refresh_pressed():
	report_list.clear()
	for n in reports:
		report_list.add_item(str(n.input.index) + "-" + str(n.index) + ": " + n.payload)


func _on_send_input_pressed():
	Cartesi.client.send_input(input_box.text)


func _on_refresh_pressed():
	await refresh_data()
	_on_notices_refresh_pressed()
	_on_reports_refresh_pressed()


func _on_view_vouchers_pressed():
	view_vouchers.emit()
