class_name CartesiInput

var index: int
var msgSender: String
var timestamp: int
var blockNumber: int
var payload: String

func _init(index: int, msgSender: String, timestamp: int, blockNumber: int, payload: String):
	self.index = index
	self.msgSender = msgSender
	self.timestamp = timestamp
	self.blockNumber = blockNumber
	self.payload = Cartesi.decode_hex(payload)


static func from_dict(data: Dictionary) -> CartesiInput:
	return CartesiInput.new(
		data["index"],
		data["msgSender"],
		data["timestamp"] as int,
		data["blockNumber"] as int,
		data["payload"]
	)


func to_dict() -> Dictionary:
	return {
		index=index,
		msgSender=msgSender,
		timestamp=timestamp,
		blockNumber=blockNumber,
		payload=payload
	}


func _to_string():
	return JSON.stringify(to_dict())
