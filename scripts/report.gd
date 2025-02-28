extends Area2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _on_body_entered(body: Node2D) -> void:
	audio_stream_player_2d.play()
	await get_tree().create_timer(0.3).timeout
	print("+1 report")
	call_deferred("queue_free")
	
