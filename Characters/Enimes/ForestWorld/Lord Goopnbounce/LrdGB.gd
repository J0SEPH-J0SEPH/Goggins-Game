extends Node2D







func _on_VisibilityNotifier2D_screen_entered():
	$Hitpoint/AnimationPlayer.play("bounce")
	$Hitpoint.Dead = false
	$Hitpoint/DamagePlayer.dead = false
	$Hitpoint.Health = $Hitpoint.MaxHealth


func _on_VisibilityNotifier2D_screen_exited():
	$Hitpoint/AnimationPlayer.stop(true)
