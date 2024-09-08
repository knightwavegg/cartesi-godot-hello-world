class_name CartesiVoucher

var index: int
var destination: String
var payload: String
var input: CartesiInput
var proof: CartesiProof

func _init(index: int, destination: String, payload: String, input: CartesiInput, proof: CartesiProof):
	self.index = index
	self.destination = destination
	self.payload = payload
	self.input = input
	self.proof = proof

static func from_dict(data: Dictionary) -> CartesiVoucher:
	var input = CartesiInput.from_dict(data["input"])
	var proof: CartesiProof = null
	if data["proof"] != null:
		proof = CartesiProof.from_dict(data["proof"])

	return CartesiVoucher.new(
		data["index"],
		data["destination"],
		data["payload"],
		input,
		proof
	)

func to_dict() -> Dictionary:
	return {
		index = index,
		destination = destination,
		payload = payload,
		input = input.to_dict(),
		proof = proof.to_dict() if proof != null else proof
	}

var gas_callback = JavaScriptBridge.create_callback(_gas_callback)

func _gas_callback(args):
	print_debug("Gas response: ", JSON.stringify(args))

func execute(dapp: JavaScriptObject):
	var jsonif = JavaScriptBridge.get_interface("JSON")
	var proof_obj = proof.to_js_object()
	print_debug("executing voucher, destination ", destination)
	print_debug("payload ", payload)
	print_debug("proof ", jsonif.stringify(proof_obj))
	dapp.executeVoucher.estimateGas( destination, payload, proof_obj).then(gas_callback)
	print_debug("Gas estimated, running tx")

	dapp.executeVoucher( destination, payload, proof_obj)
