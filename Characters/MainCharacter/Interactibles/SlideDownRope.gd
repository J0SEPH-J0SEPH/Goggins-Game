extends Node2D

var MaxXpos

var MaxYpos

var Distance = 0

var CurrentPoss = Vector2(0,0)

var newpos

var pos = 0.1

var speed = 0

var Swinger

var inposition = false

var Direction = true

var directionTraveling = 0

var compleat = false

var Ydir

var desiredpos

func _ready():
	
	
	set_physics_process(false)
	
	$Area2D/CollisionShape2D.shape = $Area2D/CollisionShape2D.shape.duplicate()
	
	var col = $Area2D/CollisionShape2D.get_shape()
	
	col.b = -($End.position + Vector2(0,25))
	col.a = -($Start.position + Vector2(0,25))
	
	if $End.position > $Start.position:
		directionTraveling = true
	else:
		directionTraveling = false
	
	
	$Line2D.set_point_position(0,$Start.position)
	$Line2D.set_point_position(1,$End.position)
	$Line2D.set_point_position(2,$End.position)
	
	Distance = $Start.global_position.distance_to($End.global_position)
	
	MaxXpos = $End.global_position.x - $Start.global_position.x
	
	MaxYpos = $End.global_position.y - $Start.global_position.y
	
	if MaxXpos == 0:
		MaxXpos = 1
		
func _physics_process(delta):
	
	
	if !compleat:
		$Line2D.set_point_position(0,$Start.position)
		$Line2D.set_point_position(1,Swinger.position-Vector2(0,+30)-position)
		$Line2D.set_point_position(2,$End.position)
	
	
		if (Input.is_action_just_pressed("jump") || pos == 1):
			
			
			
			if (Ydir-30-position.y > CurrentPoss.y-position.y+5):
				Bounce = Ydir-30-position.y
				compleat = true
			else:
				$Line2D.set_point_position(1,$End.position)
				
				set_physics_process(false)
		pos += speed * delta
		
		speed += delta
		speed = clamp(speed,0,1)
		pos = clamp(pos,0,1)
		
		CurrentPoss = lerp($Start.global_position,$End.global_position,pos)
		
		if CurrentPoss.x > MaxXpos*0.5:
			newpos = sin(((abs(MaxXpos) - (CurrentPoss.x - $Start.global_position.x))/abs(MaxXpos))*PI)
		else:
			newpos = sin(((CurrentPoss.x- $Start.global_position.x)/abs(MaxXpos))*PI)
		
		if MaxXpos < 0:
			newpos = -newpos
		
		
		Ydir = lerp(Swinger.position.y,CurrentPoss.y+((newpos*Distance*0.1)+30),speed)
		
		desiredpos =  Vector2(CurrentPoss.x, Ydir)
		
		Swinger.position = lerp(Swinger.position, desiredpos, delta *10)

		Swinger.ZipWireing(speed,pos,directionTraveling)	
			
	else:
		ResetRope(delta)


	
	
	
var Bounce
var num = 0

func ResetRope(delta: float):
	var newLinepos = $Line2D.get_point_position(1)
	
	var Yvalue = Ydir-30-position.y
	var Centurevalue = CurrentPoss.y-position.y
	
	num += 10*delta
	

	
	var Snum = cos(num)*0.5+0.5
	
	if((2*Centurevalue - Yvalue) + num < Centurevalue):
		
		Bounce =  lerp( (2*Centurevalue - Yvalue) + num, Yvalue - num,Snum)
		$Line2D.set_point_position(1,Vector2(newLinepos.x,Bounce))
	else:
		
		$Line2D.set_point_position(1,$End.position)
		
		compleat = false
		set_physics_process(false)
	
	
	

		
func _on_Area2D_body_entered(body):
	
	if body.is_in_group("Player"):
		if MaxYpos != 0 && body.YSpeed > 0 && body.CharacterStates != 10 :
			var PointPos = $Start.global_position.y + ((MaxYpos/MaxXpos)*(body.position.x-$Start.global_position.x))+30
			
			
			
			if PointPos-body.position.y > -10:
				
				compleat = false
				
				body.wallJumpValocity = 0
				body.MaxAirMovement = 90
				speed = 0
				body.YSpeed = 0
				body.CharacterStates = 10
				var Playerpos = body.position.x - $Start.global_position.x
				
				pos = Playerpos/MaxXpos
				Swinger = body
				set_process(true)
				set_physics_process(true)


