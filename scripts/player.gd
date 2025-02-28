extends CharacterBody2D

@onready var muzzle: Marker2D = $Muzzle
@onready var flashlight: Light2D = $Muzzle/Flashlight
@onready var charge_bar: TextureProgressBar = $UI/ChargeBar
@onready var sprite: Sprite2D = $CollisionShape2D/Sprite2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var flash_sound: AudioStreamPlayer2D = $"flash sound"

const DOWN = preload("res://assets/officer/down.png")
const LEFT = preload("res://assets/officer/left.png")
const RIGHT = preload("res://assets/officer/right.png")
const UP = preload("res://assets/officer/up.png")
var current_health: int
signal player_died 

const FLASHLIGHT_DISTANCE = 110.0  # Set the desired distance from the player to the flashlight

@export var max_health: int = 500
var moveSpeed = 200.0
var flashlight_on = true
var max_charge = 200.0  # Max charge for the flashlight
var current_charge = max_charge
var charge_drain_rate = 10.0  # Charge drain per second when the flashlight is on
var current_animation: String = ""
func _ready() -> void:
	add_to_group("Player")
	current_health = max_health
	charge_bar.position = Vector2(20, 20)  # Set position to top-left corner
	#take_damage(20)
func _process(delta: float) -> void:
	update_charge_bar()  # Update the charge bar UI

	if flashlight_on:  # If the flashlight is turned on
		# Drain the charge based on the rate and ensure it doesn't go below 0
		current_charge = max(current_charge - charge_drain_rate * delta, 0.0)

		# Check if there is still charge left
		if current_charge > 0:
			flashlight.visible = true  # Make the flashlight visible
		else:
			flashlight.visible = false  # Turn off the flashlight if charge is depleted
			flashlight_on = false  # Optionally turn off the flashlight if out of charge
	else:
		flashlight.visible = false  # Ensure flashlight is off when not in use
		
func play_animation(animation_name: String) -> void:
	if current_animation != animation_name:
		current_animation = animation_name
		animated_sprite.play(animation_name)  # Play the specified animation
		#print(" palying:", animation_name)

func _physics_process(_delta: float) -> void:
	var motion = Vector2.ZERO
	var new_animation = ""
	var facing_direction = Vector2.ZERO
	var is_moving = false

	
	if Input.is_action_pressed("up"):    
		motion.y -= 1
		new_animation = "up"
		#play_animation("up")
		facing_direction = Vector2.UP
		is_moving = true

	elif Input.is_action_pressed("down"):    
		motion.y += 1
		new_animation = "down"
		#play_animation("down")
		facing_direction = Vector2.DOWN
		is_moving = true

	elif Input.is_action_pressed("right"):    
		motion.x += 1
		new_animation = "right"
		#play_animation("right")
		facing_direction = Vector2.RIGHT
		is_moving = true
		
	elif Input.is_action_pressed("left"):    
		motion.x -= 1
		new_animation = "left"
		#play_animation("left")
		facing_direction = Vector2.LEFT
		is_moving = true

	else:
		new_animation = "idle_down"
		#play_animation("idle")
		
	play_animation(new_animation)
	
	if is_moving:
		update_flashlight(facing_direction, true)
	else:
		# Eğer hareket etmiyorsa fener fare yönüne bakmalı
		var mouse_pos = get_global_mouse_position()
		var direction_vector = (mouse_pos - global_position).normalized()
		update_flashlight(direction_vector,false)
		
		
	motion = motion.normalized() * moveSpeed
	velocity = motion
	move_and_slide()

func update_flashlight(direction: Vector2, is_moving: bool) -> void:
	var direction_degrees = rad_to_deg(direction.angle())
	flashlight.global_position = global_position + Vector2(FLASHLIGHT_DISTANCE, 0).rotated(deg_to_rad(direction_degrees))
	flashlight.rotation = deg_to_rad(direction_degrees + 90)
	if direction_degrees < 0:
		direction_degrees += 360

	#Determine the sprite based on the direction
	if direction_degrees >= 315 or direction_degrees < 45 and is_moving==false :
		play_animation("idle_right")  # Replace with your right sprite path
		#print("right")
	elif direction_degrees >= 45 and direction_degrees < 135 and is_moving==false:
		play_animation("idle_down")  # Replace with your up sprite path
		#print("down")
	elif direction_degrees >= 135 and direction_degrees < 225 and is_moving==false:
		play_animation("idle_left") 
		#print("left")
	elif direction_degrees >= 225 and direction_degrees < 315 and is_moving==false:
		play_animation("idle_up") # Replace with your down sprite path
		#print("up")
		
func _input(event):  # Toggle flashlight on/off
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if current_charge > 0:  # Only allow toggling if there's charge left
				flash_sound.play()
				flashlight_on = !flashlight_on

func update_charge_bar() -> void:
	charge_bar.value = current_charge / max_charge * charge_bar.max_value  # Update the UI charge bar

func take_damage(amount: int) -> void:
	current_health -= amount
	print("Player took damage! Current Health:", current_health)
	current_health = max(current_health, 0)  # Prevent health from going below zero

	if current_health <= 0:
		die()
	
func die() -> void:
	print("Player has died!")
	player_died.emit()
	print("player is dead")
	get_tree().change_scene_to_file("res://scenes/end.tscn")  # Ensure the file path is correct
# Remove player from the scene (you can change this to restart the game)
func is_flashlight_active() -> bool:
	return flashlight.visible
func is_flashlight_on() -> bool:
	return true
