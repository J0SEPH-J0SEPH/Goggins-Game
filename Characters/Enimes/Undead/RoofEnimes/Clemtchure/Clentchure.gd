extends Node2D


var pos = Vector2(0,200)

var MainBodyScript

onready var Checkground = $GroundCheck
# Called when the node enters the scene tree for the first time.
func _ready():
	
	MainBodyScript = $DetectPlayer.get_node("ClentchureAttack")
	
	set_process(false)
	
	
	if Checkground.is_colliding():
		pos =Checkground.get_collision_point()
		Checkground.enabled = false



func _on_DetectPlayer_body_entered(body):
	$DetectPlayer.set_process(true)
