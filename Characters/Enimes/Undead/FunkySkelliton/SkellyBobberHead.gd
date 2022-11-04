extends KinematicBody2D

var Pos

func _ready():
	Pos = get_parent().get_node("KinematicBody2D/Position2D")

func _physics_process(delta):
	global_position += Pos.global_position-global_position


func _on_PlayerDettection_body_entered(body):
	if body.is_in_group("Player"):
		body.SlopeSlide = false


func _on_PlayerDettection_body_exited(body):
	if body.is_in_group("Player"):
		body.SlopeSlide = true
