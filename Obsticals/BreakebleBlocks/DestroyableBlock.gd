extends Node2D

var brocken = false



func _on_Hitpoint_area_entered(area):
	if(!brocken):
		$AnimationPlayer.play("Destroyed")
		brocken = true
		
