class_name CartesiNotice

var index: int
var payload: String
var input: CartesiInput

func _init(index: int, payload: String, input: CartesiInput):
	self.index = index
	self.payload = Cartesi.decode_hex(payload)
	self.input = input

static func from_dict(data: Dictionary) -> CartesiNotice:
	var input = CartesiInput.from_dict(data["input"])
	return CartesiNotice.new(
		data["index"],
		data["payload"],
		input
	)
	
func to_dict() -> Dictionary:
	return {
		index=index,
		payload=payload,
		input=input.to_dict()
	}

func _to_string():
	return JSON.stringify(to_dict())
