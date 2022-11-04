extends Area2D


onready var Controller = get_parent()

var leftExtent = 0
var UpExtent = 0

export var Aria = 1
export var AriaBackground = 1

export var Offset1 = 0
export var Offset2 = 0
export var Offset3 = 0
export var Offset4 = 0
export var Offset5 = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	leftExtent =  scale.x*8
	UpExtent =  scale.y*8
	


func _on_Area2D_body_entered(body):
	
	if body.is_in_group("Player"):	
		var Direction = FindDirection(body)
		
		body.aria = Aria
		body.section = AriaBackground
		body.offset1 = Offset1
		body.offset2 = Offset2
		body.offset3 = Offset3
		body.offset4 = Offset4
		body.offset5 = Offset5
		if Controller.playerDead:
			Controller.playerDead = false
			return
		
		Controller.SetNewLimits(leftExtent,UpExtent,position)
			
		Controller.SignalToPlayer(Direction)
			
	#var bod = body.get_node("Camera2D")
	
	#Set Cameras Left Limit
	#bod.set_limit(0,position.x - leftExtent) 
	#Set Cameras Right Limit
	#bod.set_limit(2,position.x + leftExtent) 
	#Set Cameras Up Limit
	#bod.set_limit(1,position.y - UpExtent) 
	#Set Cameras Doown Limit
	#bod.set_limit(3,position.y + UpExtent) 


func FindDirection(body : Node2D):
	if(body.position.y > position.y + UpExtent):
		return 1
	if(body.position.x < position.x - leftExtent):
		return 2
		
	if(body.position.x > position.x + leftExtent):
		return 3
	
	return 4
	
	
