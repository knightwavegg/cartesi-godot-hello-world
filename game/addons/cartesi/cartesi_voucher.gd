class_name CartesiVoucher

var index: int
var destination: String
var payload: String
var input: CartesiInput
var proof: CartesiProof

func _init(index: int, destination: String, payload: String, input: CartesiInput, proof: CartesiProof):
	self.index = index
	self.destination = destination
	self.payload = Cartesi.decode_hex(payload)
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

func execute(dapp: JavaScriptObject, ethers: Ethers):
	#print_debug("Ohiohs:", ohiohs)
	#var ohies:Array = proof.outputHashesInEpochSiblings.map(func(n): return ethers.ethers.toUtf8Bytes(n))
	#print_debug("Ohies: ", ohies)
	
	dapp.executeVoucher(
		destination,
		ethers.ethers.toUtf8Bytes(payload),
		proof.to_js_object()
		)
