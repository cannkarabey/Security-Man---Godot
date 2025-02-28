extends Control
@onready var button_sound: AudioStreamPlayer2D = $"button sound"

# "Play" butonuna basınca sahne değiştirecek
func _on_PlayButton_pressed():
	button_sound.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/story_scene.tscn")  # Oyun sahneni buraya koy

# "Quit" butonuna basınca oyunu kapatacak
func _on_QuitButton_pressed():
	button_sound.play()
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()
