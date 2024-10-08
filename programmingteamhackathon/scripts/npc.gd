extends CharacterBody3D

@onready var agent = $NavigationAgent3D

const SPEED  = 2
var player: Node3D
var target: Vector3


func _ready():
	player = get_tree().get_root().get_node("World/Player")
	#target = player.global_transform.origin  # Set the initial target to player position
	update_target_loc(target)


func _physics_process(delta):
	# Continuously update the target to follow the player
	target =  Vector3(0,0,-20)
	#target = player.global_transform.origin
	update_target_loc(target)

	# Check if there is a valid path
	if agent.is_navigation_finished():
		return  # No need to move if we reached the target
	
	# Debug next path position
	var next_location = agent.get_next_path_position()

	# Ensure the NPC looks towards the next path position
	if next_location:
		look_at(next_location)
		rotation.x = 0  # Prevent looking up/down
		rotation.z = 0  # Prevent tilting sideways

		# Move towards the next location in the path
		if position.distance_to(next_location) > 0.5:
			var new_velocity = (next_location - global_transform.origin).normalized() * SPEED
			velocity = new_velocity
			move_and_slide()  # Pass the calculated velocity to move_and_slide()

func update_target_loc(target):
	agent.set_target_position(target)
	
#region

func enter_library():
	help_queue()
	find_book()
	pass

func help_queue():
	follow_librarian()
	copy_wait()
	pass
	
func copy_wait():
	leave_library()
	pass
	
func follow_librarian():
	target = player.global_transform.origin

	
func find_book():
	checkout_book()
	pass
	
func find_seat():
	get_loffee()
	leave_library()
	pass
	
func checkout_book():
	find_seat()
	leave_library()
	pass
	
func get_loffee():
	find_seat()
	leave_library()
	pass
	
func leave_library():
	pass
#region
