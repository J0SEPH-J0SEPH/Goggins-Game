extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var InitialGravity

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_WindShooter_body_entered(body):
	if body.is_in_group("Player"):
		body.gravity = -400
		body.Stabilgravity = -400.0
		if body.YSpeed > 300:
			body.YSpeed = 300
			


func _on_WindShooter_body_exited(body):
	if body.is_in_group("Player"):
		body.gravity = 600
		body.Stabilgravity = 600.0


