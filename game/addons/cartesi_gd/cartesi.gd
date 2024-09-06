extends Node

# TODO: break out ethers to pass between Explorer & Voucher clients
var INPUT_BOX_CONTRACT_ADDRESS = "0x59b22D57D4f067708AB0c00552767405926dc768"#Config.get("input_box_contract_address")
var DAPP_CONTRACT_ADDRESS = "0xab7528bb862fb57e8a2bcd567a2e929a0be56a5e"#Config.get("dapp_contract_address")
var GQL_ENDPOINT = "http://localhost:8080/graphql"
var client:CartesiClient
var server:CartesiServer

var is_server = OS.get_environment("SERVER_MODE")

func _init():
	if is_server:
		server = CartesiServer.new()
		add_child(server)
	else:
		client = CartesiClient.new(INPUT_BOX_CONTRACT_ADDRESS, DAPP_CONTRACT_ADDRESS, GQL_ENDPOINT)
		add_child(client)

func decode_hex(data: String) -> String:
	if data.begins_with("0x"):
		data = data.substr(2)
	return data.hex_decode().get_string_from_utf8()


func encode_hex(data: String) -> String:
	return "0x" + data.to_utf8_buffer().hex_encode()
