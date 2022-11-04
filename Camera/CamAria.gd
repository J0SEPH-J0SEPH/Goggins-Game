extends Node2D


signal EnterDoor()




var playerDead = false

var leftmost = 0

var upmost = 0

var AriaPos = Vector2.ZERO

var NoNewAria = false


#Set Cameras for new aria
func SetNewLimits(Left : int, UP : int, pos: Vector2):
	
	if( AriaPos != pos):
		leftmost = Left
		upmost = UP
		AriaPos = pos
		NoNewAria = false
	else:
		
		NoNewAria = true
		
	
		
func SignalToPlayer(Direction : int):
	if(!NoNewAria):
		emit_signal("EnterDoor",Direction,AriaPos,leftmost,upmost)
		
func _on_Goggins_ExitedDoor(Camera2d: Camera2D):
	
	#Set Cameras Left Limit
	Camera2d.set_limit(0,AriaPos.x - leftmost) 
	#Set Cameras Right Limit
	Camera2d.set_limit(2,AriaPos.x + leftmost) 
	#Set Cameras Up Limit
	Camera2d.set_limit(1,AriaPos.y - upmost) 
	#Set Cameras Doown Limit
	Camera2d.set_limit(3,AriaPos.y + upmost) 

	
func _on_Goggins_PlayerDead():
	playerDead = true
	var Cam = get_parent().UI.SaveData
	AriaPos = Vector2(Cam.camera.PositionX,Cam.camera.PositionY)
