extends Node

func publish_game_log():
	var payload = PackedByteArray([0, 0, 0, 0])
	JavaScriptBridge.eval("window.submitScore(" + str(payload) + ")")
