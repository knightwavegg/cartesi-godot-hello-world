class_name Ethers
var _ethersGD:JavaScriptObject
var _window:JavaScriptObject
var provider:JavaScriptObject
var signer:JavaScriptObject
var input_box:JavaScriptObject
var dapp:JavaScriptObject
var ethers:JavaScriptObject

var get_signer_callback = JavaScriptBridge.create_callback(_get_signer_callback)
signal wallet_connected(address:String)

func _init():
	_ethersGD = JavaScriptBridge.get_interface("ethersGD")
	ethers = _ethersGD.ethers


func connect_wallet():
	_ethersGD.connect_wallet().then(get_signer_callback)


func _get_signer_callback(args):
	wallet_connected.emit(_ethersGD.signer.address)


func sign_message(data:Dictionary):
	pass


func send_transaction(recipient:String, function:String, args:Array):
	pass


func is_wallet_available() -> bool:
	return _window.ethereum == null


func get_contract(address:String, abi:Array[String]):
	print_debug("Getting contract ", address, " with abi ", abi)
	return _ethersGD.get_contract(address, JSON.stringify(abi))

