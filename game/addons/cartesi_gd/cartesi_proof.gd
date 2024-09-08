class_name CartesiProof
var context: String

# OutputValidityProof contents
var inputIndexWithinEpoch: int
var outputIndexWithinInput: int
var outputHashesRootHash: String
var vouchersEpochRootHash: String
var noticesEpochRootHash: String
var machineStateHash: String
var outputHashInOutputHashesSiblings: Array[String]
var outputHashesInEpochSiblings: Array[String]

func to_dict():
	return {
		validity = {
			inputIndexWithinEpoch = inputIndexWithinEpoch,
			outputIndexWithinInput = outputIndexWithinInput,
			outputHashesRootHash = outputHashesRootHash,
			vouchersEpochRootHash = vouchersEpochRootHash,
			noticesEpochRootHash = noticesEpochRootHash,
			machineStateHash = machineStateHash,
			outputHashInOutputHashesSiblings = outputHashInOutputHashesSiblings,
			outputHashesInEpochSiblings = outputHashesInEpochSiblings
		},
		context = context
	}

static func from_dict(data: Dictionary):
	var proof = CartesiProof.new()
	proof.context = data["context"]
	proof.inputIndexWithinEpoch = data["validity"]["inputIndexWithinEpoch"]
	proof.outputIndexWithinInput = data["validity"]["outputIndexWithinInput"]
	proof.outputHashesRootHash = data["validity"]["outputHashesRootHash"]
	proof.vouchersEpochRootHash = data["validity"]["vouchersEpochRootHash"]
	proof.noticesEpochRootHash = data["validity"]["noticesEpochRootHash"]
	proof.machineStateHash = data["validity"]["machineStateHash"]
	proof.outputHashInOutputHashesSiblings.assign(data["validity"]["outputHashInOutputHashesSiblings"])
	proof.outputHashesInEpochSiblings.assign(data["validity"]["outputHashesInEpochSiblings"])
	return proof

func to_js_object():
	var obj = JavaScriptBridge.create_object("Array")
	var validity = JavaScriptBridge.create_object("Array")
	var ohiohs = JavaScriptBridge.create_object("Array")
	var ohies = JavaScriptBridge.create_object("Array")
	for i in outputHashInOutputHashesSiblings.size():
		ohiohs[i] = outputHashInOutputHashesSiblings[i]
	
	for i in outputHashesInEpochSiblings.size():
		ohies[i] = outputHashesInEpochSiblings[i]
	
	validity[0] = inputIndexWithinEpoch
	validity[1] = outputIndexWithinInput
	validity[2] = outputHashesRootHash
	validity[3] = vouchersEpochRootHash
	validity[4] = noticesEpochRootHash
	validity[5] = machineStateHash
	validity[6] = ohiohs
	validity[7] = ohies

	#validity.inputIndexWithinEpoch = inputIndexWithinEpoch
	#validity.outputIndexWithinInput = outputIndexWithinInput
	#validity.outputHashesRootHash = outputHashesRootHash
	#validity.vouchersEpochRootHash = vouchersEpochRootHash
	#validity.noticesEpochRootHash = noticesEpochRootHash
	#validity.machineStateHash = machineStateHash
	#validity.outputHashInOutputHashesSiblings = outputHashInOutputHashesSiblings
	#validity.outputHashesInEpochSiblings = outputHashesInEpochSiblings
	
	obj[0] = validity
	obj[1] = context
	var console = JavaScriptBridge.get_interface("console")
	console.log(obj.toString())
	return obj
