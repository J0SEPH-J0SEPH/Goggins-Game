extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func SetTile(Xpos: int,Ypos: int):

	$ColorRect/ChildOffset/Cover.set_cell(Xpos,Ypos,-1,false,false,false,Vector2.ZERO)
	$ColorRect/ChildOffset/MiniMap.position = Vector2(24-(Xpos*8),16-(Ypos*8))
	$ColorRect/ChildOffset/Cover.position = Vector2(24-(Xpos*8),16-(Ypos*8))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
