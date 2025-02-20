extends Node3D

func _ready() -> void:
	var http_manager = load("res://Network/WebSocketManager.gd").new()
	add_child(http_manager)
	http_manager.connect("animation_requested", Callable(self, "_on_animation_requested"))

func _on_animation_requested(animation_type: String) -> void:
	var poc_node = get_node_or_null("poc")
	if poc_node == null:
		print("poc node not found - check that you instanced it and the node path is correct.")
		return

	var anim_player = poc_node.get_node_or_null("AnimationPlayer")
	if anim_player == null:
		print("AnimationPlayer not found in poc node!")
		return

	match animation_type:
		"flair_dance":
			anim_player.play("flair_dance")
		"breakdance":
			anim_player.play("breakdance")
		"hip_hop_dance":
			anim_player.play("hip_hop_dance")
		_:
			print("Unknown animation:", animation_type)
