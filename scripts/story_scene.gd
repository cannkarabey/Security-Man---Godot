extends Control

@onready var button_sound: AudioStreamPlayer2D = $"button sound"

func _on_skip_button_pressed() -> void:
	button_sound.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/room_1.tscn")  # Oyuna geçiş yap
