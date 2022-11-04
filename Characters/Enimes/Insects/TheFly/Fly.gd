extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var t = 0

export var Xmultiplyer = 1

export var Ymultiplyer = 4

export var Speed = 1



func _process(delta):
	
	t += Speed*0.01
	
	position.x += sin(t*Xmultiplyer)
	position.y += sin(t*Ymultiplyer)


func _ready():
	set_process(false)
	
	


func _on_VisibilityNotifier2D_screen_exited():
	set_process(false)
	$Hitpoint/Fly.stop(true)


func _on_VisibilityNotifier2D_screen_entered():
	set_process(true)
	$Hitpoint/Fly.play("Fly")

