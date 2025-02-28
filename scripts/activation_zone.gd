extends Area2D

@export var enemy: Node  # Assign the enemy node in the Inspector
@onready var ghoul: CharacterBody2D = $"../Ghoul"

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):  # Ensure the body is the player
		enemy.set_process(true)  # Start processing the enemy
		print("passed")
		queue_free()  # Optionally, remove the activation zone after triggeringplace with function body.
