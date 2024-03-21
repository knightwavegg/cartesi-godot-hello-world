class_name CartesiVoucher

var index: int
var destination: String
var payload: String
var input: CartesiInput

func _init(index: int, destination: String, payload: String, input: CartesiInput):
	self.index = index
	self.destination = destination
	self.payload = Cartesi.decode_hex(payload)
	self.input = input

static func from_dict(data: Dictionary) -> CartesiVoucher:
	var input = CartesiInput.from_dict(data["input"])
	return CartesiVoucher.new(
		data["index"],
		data["destination"],
		data["payload"],
		input
	)
	
func to_dict() -> Dictionary:
	return {
		index=index,
		destination=destination,
		payload=payload,
		input=input.to_dict()
	}

func _to_string():
	return JSON.stringify(to_dict())
