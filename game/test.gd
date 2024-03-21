extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var ethers = JavaScriptBridge.get_interface("ethers")
	#var _debug_callback = JavaScriptBridge.create_callback(_print_response)
	#var provider = JavaScriptBridge.get_interface("web3Provider")
	#var signer = provider.getSigner()
	#provider.getBlockNumber().then(_debug_callback)
	#var payload = "0x54657374696e6720313233"
	#decode(payload)


func _print_response(args):
	print(args)


func decode(data: String):
	if data.begins_with("0x"):
		data = data.substr(2)
	print_debug(data.hex_decode().get_string_from_utf8())
