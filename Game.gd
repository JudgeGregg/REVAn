extends Node

var currentAnom: int = 0
var oldAnom: int = 0
var score: int = 0
var failed: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	$FailedLabel.hide()
	#$Music.play()
	get_tree().call_group("anomalies", "hide")
	randomize()
	
func _on_SpawnTimer_timeout():
	oldAnom = currentAnom
	while oldAnom == currentAnom:
		currentAnom = randi() % 12 + 1
	#currentAnom = 6
	$NextLabel.text = "Next: " + str(currentAnom) + "h"
	get_node("MeshInstance/Anomaly"+str(currentAnom)).show()


func _on_DestroyTimer_timeout():
	$FailedLabel.hide()
	if oldAnom != 0 and oldAnom != currentAnom:
		get_node("MeshInstance/Anomaly"+str(oldAnom)).hide()
	if oldAnom != 0:
		var anom = get_node("MeshInstance/Anomaly"+str(oldAnom))
		var player = $StaticBody
		var player_transform_2d = Vector2(player.transform.basis.x.x, player.transform.basis.x.z).normalized()
		var direction = anom.transform.origin - player.transform.origin
		var direction_2d = Vector2(direction.x, direction.z)
		#var a = Vector2(direction.normalized().x, direction.normalized().z)
		#var b = Vector2(player.transform.basis.x.x, player.transform.basis.x.z)
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
	$DestroyTimer.start()
