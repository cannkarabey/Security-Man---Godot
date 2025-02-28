extends CharacterBody2D

@export var player: Node2D  # Assign the player node in the Inspector
@export var evaporation_time: float = 4.0  # Time required to evaporate
@export var speed: float = 50.0  # Speed of the enemy
@export var damage_amount: int = 5  # Damage dealt to the player on contact
@onready var monster_sound: AudioStreamPlayer2D = $"Monster Sound"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var evaporating: bool = false
var time_elapsed: float = 0.0

func _ready() -> void:
	set_process(false)
	await get_tree().create_timer(2).timeout
	monster_sound.play()
	player = get_tree().get_first_node_in_group("Player")  # Ensure the player is found
	if player:
		player.player_died.connect(_on_player_died)  # Connect signal only if player is valid
	else:
		push_error("Player not found! Make sure the player is in the 'Player' group.")

func _on_player_died():
	print("Player is gone! Enemy stops following.")
	player = null  # 🔥 Prevent accessing a freed object
	set_process(false) 
	if not player:
		player = get_tree().get_first_node_in_group("Player")
	if not player:
		push_error("Player not found! Make sure the player is in the 'Player' group.")
	set_process(true)
# ivmeli koşu eklenebilir
func _physics_process(delta: float) -> void:
	if evaporating:
		queue_free()
		return
func _process(delta: float) -> void:
	if not evaporating:
		follow_player()
		if player.is_flashlight_on():
			time_elapsed += delta
			if time_elapsed >= evaporation_time:
				evaporate()
		else:
			time_elapsed = 0.0  # Reset the timer if the flashlight is off
		check_collision()

func follow_player() -> void:
	if player and is_instance_valid(player):  
		var direction = (player.global_position - global_position).normalized()
		var collision = move_and_collide(direction * speed * get_physics_process_delta_time())

		if collision:  # ✅ Check for collision
			var collider = collision.get_collider()
			if collider == player:
				print("Collision detected! Enemy touching player.")
				player.take_damage(damage_amount)

		# Determine animation based on movement direction
		if abs(direction.x) > abs(direction.y):  
			if direction.x > 0:
				animated_sprite.play("right")
			else:
				animated_sprite.play("left")
		else:  
			if direction.y > 0:
				animated_sprite.play("down")
			else:
				animated_sprite.play("up")
	else:
		print("Warning: Player reference is missing!")  # Debugging info
"""func is_flashlight_on() -> bool:
	# Check if the flashlight is on (this could be a signal from the player)
	return player.flashlight.visible  # Adjuast this depending on how yousssss manage the flashligh"""

func evaporate() -> void:
	animated_sprite.play("evaporate")
	await get_tree().create_timer(0.6).timeout
	evaporating = true  
	print("Enemy is evaporating!")
	# Optionally, trigger animations or visual effects for evaporation
func check_collision() -> void:
	print("Checking for collision with player...")
	if player and global_position.distance_to(player.global_position) < 30:  # Adjust distance if needed
		print("Enemy touching player!")
		player.die(damage_amount)  # Call player's take_damage function
