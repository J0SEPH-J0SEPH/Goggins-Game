extends KinematicBody2D


const FLOOR_Normal = Vector2.UP

const SNAP_DIRECTION = Vector2.DOWN

const SNAP_LENGTH = 8

var SnapVector = SNAP_DIRECTION*SNAP_LENGTH

const FLOOR_MAX_ANGLE = deg2rad(50)
# Declare member variables here. Examples:
# var a = 2
var velocity = Vector2.ZERO

var WasColliding = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

export var FacingLeft = false

var Xspeed = 100

func _process(delta):
	
	velocity.x = Xspeed
	
	velocity.y += 600*delta
	
	velocity.y = move_and_slide_with_snap(velocity,SnapVector  ,FLOOR_Normal,true,4,FLOOR_MAX_ANGLE).y
	
	if WasColliding:
		
		if is_on_floor():
			$AnimatedSprite.play("Walk")
			

			if !$CheckJump.is_colliding() :
				velocity.y = -300
				WasColliding = false
			
	else:
		if !is_on_floor():
			$AnimatedSprite.play("Jump")
		
		if $CheckJump.is_colliding():
			WasColliding = true
			
		
		
			
			
			
	if is_on_wall():
		CheckDirections()
		
func CheckDirections():
	if FacingLeft:
		
		$AnimatedSprite.scale.x = 1
		Xspeed = 100
		$CheckJump.position.x = 16 
		FacingLeft = false
	else:
	
		$AnimatedSprite.scale.x = -1
		Xspeed = -100
		$CheckJump.position.x = -16 
		FacingLeft = true
