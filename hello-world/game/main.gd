extends Node

var server_scene := preload("res://server.tscn")
var client_scene := preload("res://client.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if OS.get_environment("SERVER_MODE") == "true":
		var instance = server_scene.instantiate()
		add_child(instance)
	else:
		var instance = client_scene.instantiate()
		add_child(instance)
