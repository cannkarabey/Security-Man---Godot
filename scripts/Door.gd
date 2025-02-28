extends Area2D  

@export var target_scene_path: String  # Assign the next scene path in the Inspector

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Door entered, changing scene to:", target_scene_path)
		if target_scene_path.is_empty():
			print("Error: No target scene assigned!")
			return
		call_deferred("change_scene")  # Defer the scene change

func change_scene() -> void:
	get_tree().change_scene_to_file(target_scene_path)  # ✅ Scene change is now deferred
	call_deferred("queue_free")  # ✅ Safe removal of the node ani değişimleri önledi 
