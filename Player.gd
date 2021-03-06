extends KinematicBody

var dragging = false
var mouse_sensitivity = 0.15
var move_speed = 5.0

var dir = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.get_button_index() == 2:
			dragging = true
		else:
			dragging = false
	if event is InputEventMouseMotion and dragging:
		rotate_y(deg2rad(-event.relative.x) * mouse_sensitivity)
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	if Input.is_key_pressed(KEY_R):
		get_tree().get_root().get_node("Game").score = 0
		get_tree().get_root().get_node("Game/ScoreLabel").text = "Score: 0"
		get_tree().get_root().get_node("Game").failed = false

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)

func process_input(delta):
	# Walking
	dir = Vector3()
	var cam_xform = $Camera.get_global_transform()

	var input_movement_vector = Vector2()

	if Input.is_action_pressed("forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("right"):
		input_movement_vector.x += 1

	input_movement_vector = input_movement_vector.normalized()

	# Basis vectors are already normalized.
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x

func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()
	dir.x = dir.x * move_speed * delta
	dir.z = dir.z * move_speed * delta
	if move_and_collide(dir):
		get_tree().get_root().get_node("Game").score -= 1
		get_tree().get_root().get_node("Game/FailedLabel").text = "COLLISION!"
		get_tree().get_root().get_node("Game/FailedLabel").show()
		get_tree().get_root().get_node("Game/ScoreLabel").text = "Score: " + str(get_tree().get_root().get_node("Game").score)
