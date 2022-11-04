extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var speed = 300

# Called when the node enters the scene tree for the first time.
func _process(delta):
	position += Vector2(speed*delta*scale.x,0)
	
