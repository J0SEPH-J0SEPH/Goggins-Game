extends Area2D

onready var Forward_Raycast = $Raycasts/Forwards

onready var Down_Raycast = $Raycasts/Down


var MoveDirection = Vector2(1,0)

var Speed = 100

var currentDirection = 0

var goingLeft =  true

var Rot = 0.5

func _ready():
	if goingLeft:
		Forward_Raycast.position.x = -Forward_Raycast.position.x
		Down_Raycast.position.x = -Down_Raycast.position.x
		Forward_Raycast.cast_to = Vector2(-12,0)
		Rot = -Rot
var beenturned

func _process(delta):
	
	
	
	
	if Forward_Raycast.is_colliding():
		
		rotate(PI*-Rot)
		if !goingLeft:
			currentDirection = (currentDirection + 1) if currentDirection < 3 else 0
		else:
			currentDirection = (currentDirection - 1) if currentDirection > 0 else 3
		
		NewDirection()
		#print(currentDirection)
	else:
		if !Down_Raycast.is_colliding() && !beenturned:
			rotate(PI*Rot)
			if !goingLeft:
				currentDirection = (currentDirection - 1) if currentDirection > 0 else 3
			else:
				currentDirection = (currentDirection + 1) if currentDirection < 3 else 0
			
			NewDirection()
			beenturned = true
	
	if Down_Raycast.is_colliding():
		beenturned = false
		
	if !goingLeft:	
		position += MoveDirection * delta * Speed
	else:
		position += MoveDirection * delta * -Speed
		
func NewDirection():
	match  currentDirection:
		0:
			#GoingRight
			MoveDirection = Vector2(1,0)
			
		1:
			#GoingUp
			MoveDirection = Vector2(0,-1)
			
		2:
			#GoingLeft
			MoveDirection = Vector2(-1,0)
			
		3:
			#GoingDown
			MoveDirection = Vector2(0,1)
