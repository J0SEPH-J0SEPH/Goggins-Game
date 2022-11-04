extends Area2D


export var TilePosX = 0

export var TilePosY= 0


func _on_TileCube_body_entered(body):
	if body.is_in_group("Player"):
		get_parent().SetTile(TilePosX,TilePosY)
