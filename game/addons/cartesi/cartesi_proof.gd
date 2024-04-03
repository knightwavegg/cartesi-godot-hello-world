class_name CartesiProof
var context:String


# OutputValidityProof contents
var inputIndexWithinEpoch:int
var outputIndexWithinInput:int
var outputHashesRootHash: String
var vouchersEpochRootHash: String
var noticesEpochRootHash: String
var machineStateHash: String
var outputHashInOutputHashesSiblings: Array[String]
var outputHashesInEpochSiblings: Array[String]


func to_dict():
	return {
		validity= {
			inputIndexWithinEpoch= inputIndexWithinEpoch,
			outputIndexWithinInput= outputIndexWithinInput,
			outputHashesRootHash= outputHashesRootHash,
			vouchersEpochRootHash= vouchersEpochRootHash,
			noticesEpochRootHash= noticesEpochRootHash,
			machineStateHash= machineStateHash,
			outputHashInOutputHashesSiblings= outputHashInOutputHashesSiblings,
			outputHashesInEpochSiblings= outputHashesInEpochSiblings
		},
		context= context
	}

static func from_dict(data:Dictionary):
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
