extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const HALF_PI = 1.5707963268

var sensitivity = 0.005
var holding = false
var pull_power = 4
var collider


@onready var hand = $Camera3D/hand
@onready var interaction = $Camera3D/Interaction
@onready var camera = $Camera3D



func _enter_tree():
	set_multiplayer_authority(str(name).to_int())


func _ready():
	if not is_multiplayer_authority(): return
	interaction.enabled = true
	camera.current = is_multiplayer_authority()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	if not is_multiplayer_authority(): return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -HALF_PI, HALF_PI)
		
		
func _physics_process(delta):
	if not is_multiplayer_authority(): return
		
	if Input.is_action_just_pressed("quit"):
		$"../".exit_game(name.to_int())
		get_tree().quit()
	# Add the gravity.
	
	if Input.is_action_just_pressed("interaction"):
		interaction.force_raycast_update()  # Update the raycast position
		if interaction.is_colliding():
			collider = interaction.get_collider()
			holding = not holding
			
	if not holding:
		collider = null
	
	if holding:
		#and collider.is_in_group("pickup"):  # Check if it’s a pickup item
		if collider:
			collider.global_transform.origin = hand.global_position

		
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

	
