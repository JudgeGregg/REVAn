extends Node

var currentAnom: int = 0
var currentAnomLabel: String
var oldAnom: int = 0
var score: int = 0
var failed: bool = false
var array = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
var sampled

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.window_fullscreen = true
	$FailedLabel.hide()
	get_tree().call_group("anomalies", "hide")
	randomize()
	
func sample(list,amt):
	var shuffled = list.duplicate()
	shuffled.shuffle()
	var sampled_ = []
	for _i in range(amt):
		sampled_.append( shuffled.pop_front() )
	return sampled_
	
func _on_SpawnTimer_timeout():
	array.shuffle()
	sampled = sample(array, 4)
	for anom in sampled:
		get_node("MeshInstance/Anomaly"+str(anom)).show()
	currentAnom = sampled.pop_front()
	currentAnomLabel = get_currentAnomLabel(currentAnom)
	$NextLabel.text = "Next: " + currentAnomLabel
	$DestroyTimer2.start()
	$DestroyTimer4.start()
	$DestroyTimer6.start()
	$DestroyTimer8.start()

func get_currentAnomLabel(currentAnom):
	if currentAnom == 13:
		currentAnomLabel = "3i"
	elif currentAnom == 14:
		currentAnomLabel = "9i"
	else:
		currentAnomLabel = str(currentAnom) + "h"

func _on_DestroyTimer_timeout():
	check_failed()
	if len(sampled) > 0:
		currentAnom = sampled.pop_front()
		currentAnomLabel = get_currentAnomLabel(currentAnom)
		$NextLabel.text = "Next: " + currentAnomLabel
	else:
		$NextLabel.text = "Please wait..."
		$SpawnTimer.start()

func check_failed():
	$FailedLabel.hide()
	get_node("MeshInstance/Anomaly"+str(currentAnom)).hide()
	var anom = get_node("MeshInstance/Anomaly"+str(currentAnom))
	var player = $StaticBody
	var player_transform_2d = Vector2(player.transform.basis.x.x, player.transform.basis.x.z).normalized()
	var direction = anom.transform.origin - player.transform.origin
	var direction_2d = Vector2(direction.x, direction.z)
	var a = Vector2(direction_2d.normalized().x, direction_2d.normalized().y)
	var b = Vector2(player_transform_2d.x, player_transform_2d.y)
	var delta = rad2deg(acos(a.dot(b)))
	print(delta)
	if delta > 5.5:
		failed = true;
		$FailedLabel.text = "FAILED! (" + str(round(delta)) + "°)"
		$FailedLabel.show()
	if not failed:
		score +=1 
		$ScoreLabel.text = "Score: " + str(score)

func _on_Button_pressed():
	$FirstMenu.hide()
	$ScoreLabel.show()
	$NextLabel.show()
	$SpawnTimer.start()
