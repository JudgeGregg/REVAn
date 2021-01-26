extends StaticBody
var dragging = false

var mouse_sensitivity = 0.15

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


