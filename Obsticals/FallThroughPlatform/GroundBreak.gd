extends Node2D

var Destroyed = false

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player") && !Destroyed:
		$AnimationPlayer.play("FallThrough")
		Destroyed = true
		
