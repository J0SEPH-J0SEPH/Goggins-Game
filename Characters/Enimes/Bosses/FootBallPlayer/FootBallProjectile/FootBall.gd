extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var Yspeed = 10

var Xspeed = -3



export var CastDire = 11

var PlayersBall = false

# Called when the node enters the scene tree for the first time.

func _ready():
	set_process(false)

func _process(delta):
	
	position.y += Yspeed
	
	position.x += Xspeed
	
	Yspeed += 10*delta
	
	if $RayCast2D.is_colliding():
		Yspeed = -300*delta
	
	if $FrontRay.is_colliding():
		SwitchDirections()
		
		if abs(Xspeed) > 1:
			if Xspeed < 0:
				Xspeed += 1
			else:
				Xspeed -= 1

func SwitchDirections():
	
	Xspeed = -Xspeed
	$AnimatedSprite.scale.x = -$AnimatedSprite.scale.x
	$FrontRay.set_cast_to(-$FrontRay.get_cast_to())
	
var Damage = 2

func _on_FootBall_body_entered(body):
	if body.is_in_group("Player") && PlayersBall == false:
		body.HealthUpdated(Damage)
		



func _on_FootBall_area_entered(area):
	if area.is_in_group("ShovelSwing"):
		PlayersBall = true
		modulate = Color.red
		if area.ShootingLeft == true:
			if Xspeed < 0:
				SwitchDirections()
			Xspeed = 3
		else:
			if Xspeed > 0:
				SwitchDirections()
			Xspeed = -3


func _on_VisibilityEnabler2D_screen_entered():
	set_process(true)


func _on_VisibilityEnabler2D_screen_exited():
	queue_free()
