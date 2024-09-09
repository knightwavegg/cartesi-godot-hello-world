class_name EthersGD
extends Node

var provider:JavaScriptObject
var signer:JavaScriptObject
var ethers:JavaScriptObject
var ethereum:JavaScriptObject
var ethersGD:JavaScriptObject

var get_signer_callback = JavaScriptBridge.create_callback(_get_signer_callback)
signal wallet_connected(address:String)


func _ready():
	if OS.has_feature("web"):
		print_debug("Readying EthersGD")
		ethereum = JavaScriptBridge.get_interface("ethereum")
		if ethereum:
			print_debug("Found ethereum interface.")
		else:
			print_debug("Error: ethereum interface not found.")

		ethers = JavaScriptBridge.get_interface("ethers")
		if ethers:
			print_debug("EtherGD found ethers.js.")
		else:
			print_debug("Error: EthersGD not found.")
		update_ethersgd("window.ethersGD = {provider:null, signer:null, contractMap:{}}")
		if ethers:
			print_debug("EtherGD found ethersGD interface.")
		else:
			print_debug("Error: Could not establish ethersGD JS interface.")


func connect_wallet(): 
	update_ethersgd("window.ethersGD.provider = new ethers.BrowserProvider(window.ethereum)")
	provider = ethersGD.provider
	provider.getSigner().then(get_signer_callback)


func _get_signer_callback(args):
	signer = args[0]
	ethersGD.signer = signer
	wallet_connected.emit(signer.address)


func sign_message(data:Dictionary):
	pass


func send_transaction(recipient:String, function:String, args:Array):
	pass


func is_wallet_available() -> bool:
	return ethereum != null


func to_utf8_bytes(data:String):
	print_debug("Converting ", data, " to utf8 bytes")
	return ethers.toUtf8Bytes(data)


func get_contract(address:String, abi:Array[String], contract_name:String):
	var eval_strfmt := "window.ethersGD.contractMap[\"%s\"] = new ethers.Contract(\"%s\", %s, window.ethersGD.signer)" 
	var eval_str := eval_strfmt % [contract_name, address, JSON.stringify(abi)]
	update_ethersgd(eval_str)
	return ethersGD.contractMap[contract_name]


func update_ethersgd(js_eval:String):
	print_debug("Running JS eval: `", js_eval, "`.")
	JavaScriptBridge.eval(js_eval)
	ethersGD = JavaScriptBridge.get_interface("ethersGD")
