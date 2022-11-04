extends Area2D




func _on_SavePoint1_body_entered(body):
	if body.is_in_group("Player"):
		if (body.CharacterStates != 7):
			body.SaveGame()
			$AnimationPlayer.play("Swing")
		
