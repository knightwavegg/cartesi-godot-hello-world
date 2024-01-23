class_name CartesiClient
extends Node

var gql := GQLClient.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	gql.set_endpoint(false, "localhost", 4000, "/graphql")


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
				}
			}
		}
	}'
	var resp = await execute_query(query)
	var vouchers_raw = resp["data"]["vouchers"]["edges"]
	var vouchers: Array[CartesiVoucher] = []
	for n in vouchers_raw:
		var voucher = CartesiVoucher.from_dict(n["node"])
		vouchers.append(voucher)
	print_debug(vouchers)
	return vouchers


