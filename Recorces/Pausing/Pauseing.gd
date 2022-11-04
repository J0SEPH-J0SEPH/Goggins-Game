extends Node2D



signal PauseGame()

var GamePaused = false


func PauseGame():
	get_tree().paused = true
	GamePaused = true

func UnpauseGame():
	get_tree().paused = false
	GamePaused = false
	
func _process(delta):
	
	
	
	if Input.is_action_just_pressed("Pause"):
		if !GamePaused:
			
			GamePaused = true
			
			emit_signal("PauseGame",true)
			
			get_tree().paused = true
			
		else:
			
			
			GamePaused = false
			emit_signal("PauseGame",false)
			get_tree().paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
