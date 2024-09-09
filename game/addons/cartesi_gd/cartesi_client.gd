extends Node
class_name CartesiClient

const input_abi:Array[String] = [ "function addInput(address _dapp, bytes _input)" ]
var input_box:JavaScriptObject

const OutputValidityProof = "(uint64, uint64, bytes32, bytes32, bytes32, bytes32, bytes32[], bytes32[])"
const Proof = "(" + OutputValidityProof + ", bytes)"
const dapp_abi:Array[String] = [ "function executeVoucher(address _destination, bytes _payload, " + Proof + "_proof)" ]
var dapp:JavaScriptObject

var gql := GQLClient.new()

var input_box_address:String
var dapp_address:String

func _init(input_box_contract_address:String, dapp_contract_address:String, gql_endpoint:String):
	input_box_address = input_box_contract_address
	dapp_address = dapp_contract_address
	gql.set_endpoint(gql_endpoint)


func _ready():
	Ethers.wallet_connected.connect(_on_wallet_connected)

func _on_wallet_connected(address:String):
	# TODO: Break these out to a config file
	input_box = Ethers.get_contract(input_box_address, input_abi, "input_box")
	dapp = Ethers.get_contract(dapp_address, dapp_abi, "dapp")


func send_input(data:String):
	input_box.addInput(dapp.target, Ethers.to_utf8_bytes(data))


func execute_voucher(voucher:CartesiVoucher):
	print_debug("Executing voucher: ", str(voucher))
	voucher.execute(dapp)


func list_inputs(args={first=10}) -> Array[CartesiInput]:
	var gql_args = parse_gql_args(args)
	var query = '{
		inputs(%s) {
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
	}' % gql_args
	var resp = await execute_query(query)
	# TODO: Error handling on empty response
	print_debug("Inputs: ", JSON.stringify(resp))
	var inputs_raw = resp["data"]["inputs"]["edges"]
	var inputs: Array[CartesiInput] = []

	for n in inputs_raw:
		var input = CartesiInput.from_dict(n["node"])
		inputs.append(input)

	print_debug(inputs)
	return inputs


func list_notices(args={first=10}) -> Array[CartesiNotice]:
	var gql_args = parse_gql_args(args)
	var query = "{
		notices(%s) {
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
	}" % gql_args

	var resp = await execute_query(query)
	# TODO: Error handling on empty response
	print_debug("Notices: ", JSON.stringify(resp))
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
	

func list_reports(args={first=10}) -> Array[CartesiReport]:
	var gql_args = parse_gql_args(args)
	var query = '{
		reports(%s) {
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
	}' % gql_args

	var resp = await execute_query(query)
	# TODO: Error handling on empty response
	print_debug("Reports: ", JSON.stringify(resp))
	var reports_raw = resp["data"]["reports"]["edges"]
	var reports: Array[CartesiReport] = []

	for n in reports_raw:
		var report = CartesiReport.from_dict(n["node"])
		reports.append(report)

	print_debug(reports)
	return reports


func list_vouchers(args={first=10}) -> Array[CartesiVoucher]:
	var gql_args = parse_gql_args(args)
	var query = '{
		vouchers(%s) {
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
	}' % gql_args

	var resp = await execute_query(query)
	# TODO: This will throw an error if response is empty
	
	print_debug("Vouchers: ", JSON.stringify(resp))
	var vouchers_raw = resp["data"]["vouchers"]["edges"]
	var vouchers: Array[CartesiVoucher] = []
	print_debug("Raw vouchers: ", vouchers_raw)
	for n in vouchers_raw:
		var voucher = CartesiVoucher.from_dict(n["node"])
		vouchers.append(voucher)

	print_debug(vouchers)
	return vouchers

func get_voucher_proof(voucher_index:int, input_index:int) -> CartesiProof:
	var query = '{
		voucher(voucherIndex:%d, inputIndex:%d) {
			index
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
	}' % [voucher_index, input_index]
	var resp = await execute_query(query)
	# TODO: This will throw an error if response is empty
	
	print_debug("Voucher proof: ", JSON.stringify(resp))
	var voucher_raw = resp["data"]["voucher"]
	print_debug("Raw voucher: ", voucher_raw)
	return null


func parse_gql_args(args:Dictionary) -> String:
	# TODO: Combine filters if multiple are specified, add error handling if incompatible ones specified
	var args_str = "first: 10"
	if args.has( "first" ):
		args_str = "first: " + str(args["first"])
	elif args.has( "last" ):
		args_str = "last: " + str(args["last"])

	if args.has( "after" ):
		args_str = "after: " + str(args["after"])
	elif args.has( "before" ):
		args_str = "before: " + str(args["before"])

	if args.has( "where" ):
		args_str = "where: " + str(args["where"])
	return args_str
