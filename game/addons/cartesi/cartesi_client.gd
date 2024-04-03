class_name CartesiClient
extends Node

const OutputValidityProof = "(uint256, uint256, bytes32, bytes32, bytes32, bytes32, bytes32[], bytes32[])"
const Proof = "(" + OutputValidityProof + ", bytes)"
const input_abi:Array[String] = [ "function addInput(address _dapp, bytes _input)" ]
const dapp_abi:Array[String] = [ "function executeVoucher(address _destination, bytes _payload, " + Proof + "_proof)" ]
var input_box:JavaScriptObject
var dapp:JavaScriptObject

var gql := GQLClient.new()

var ethers:Ethers

# Called when the node enters the scene tree for the first time.
func _ready():
	gql.set_endpoint(false, "localhost", 8080, "/graphql")
	ethers = await Ethers.new()
	ethers.wallet_connected.connect(_on_wallet_connected)


func _on_wallet_connected(address:String):
	print_debug("Wallet connected: ", address)
	input_box = ethers.get_contract("0x59b22D57D4f067708AB0c00552767405926dc768", input_abi)
	dapp = ethers.get_contract("0x70ac08179605AF2D9e75782b8DEcDD3c22aA4D0C", dapp_abi)


func connect_wallet():
	ethers.connect_wallet()


func send_input(data:String):
	input_box.addInput(dapp.target, ethers.ethers.toUtf8Bytes(data))


func execute_voucher(voucher:CartesiVoucher):
	print_debug("Executing voucher: ", str(voucher))
	dapp.executeVoucher(voucher.destination, ethers.ethers.toUtf8Bytes(voucher.payload), voucher.proof.to_dict())


func list_inputs(last=10) -> Array[CartesiInput]:
	var query = '{
		inputs(first: 10) {
			edges {
				node {
					index
					msgSender
					timestamp
					blockNumber
					payload
				}
			}
		}
	}'
	var resp = await execute_query(query)
	var inputs_raw = resp["data"]["inputs"]["edges"]
	var inputs: Array[CartesiInput] = []

	for n in inputs_raw:
		var input = CartesiInput.from_dict(n["node"])
		inputs.append(input)

	print_debug(inputs)
	return inputs


func list_notices(last=10) -> Array[CartesiNotice]:
	var query = '{
		notices(first: 10) {
			edges {
				node {
					index
					input {
						index
						msgSender
						timestamp
						blockNumber
						payload
					}
					payload
				}
			}
		}
	}'
	var resp = await execute_query(query)
	var notices_raw = resp["data"]["notices"]["edges"]
	var notices: Array[CartesiNotice] = []

	for n in notices_raw:
		var notice = CartesiNotice.from_dict(n["node"])
		notices.append(notice)

	print_debug(notices)
	return notices


func execute_query(query: String) -> Dictionary:
	var executor := gql.raw(query)
	add_child(executor)
	executor.run()
	var resp = await executor.graphql_response
	return resp
	

func list_reports(last=10) -> Array[CartesiReport]:
	var query = '{
		reports(first: 10) {
			edges {
				node {
					index
					input {
						index
						msgSender
						timestamp
						blockNumber
						payload
					}
					payload
				}
			}
		}
	}'
	var resp = await execute_query(query)
	var reports_raw = resp["data"]["reports"]["edges"]
	var reports: Array[CartesiReport] = []

	for n in reports_raw:
		var report = CartesiReport.from_dict(n["node"])
		reports.append(report)

	print_debug(reports)
	return reports


func list_vouchers(last=10) -> Array[CartesiVoucher]:
	var query = '{
		vouchers(first: 10) {
			edges {
				node {
					index
					input {
						index
						msgSender
						timestamp
						blockNumber
						payload
					}
					destination
					payload
					proof {
						context
						validity {
							inputIndexWithinEpoch
							outputIndexWithinInput
							outputHashesRootHash
							vouchersEpochRootHash
							noticesEpochRootHash
							machineStateHash
							outputHashInOutputHashesSiblings
							outputHashesInEpochSiblings
						}
					}
				}
			}
		}
	}'
	var resp = await execute_query(query)
	# TODO: This will throw an error if response is empty
	
	var vouchers_raw = resp["data"]["vouchers"]["edges"]
	var vouchers: Array[CartesiVoucher] = []
	print_debug("Raw vouchers: ", vouchers_raw)
	for n in vouchers_raw:
		var voucher = CartesiVoucher.from_dict(n["node"])
		vouchers.append(voucher)

	print_debug(vouchers)
	return vouchers
