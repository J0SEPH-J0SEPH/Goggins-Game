extends Area2D




func _on_Springplant_body_entered(body):
	if body.is_in_group("Player"):
		if body.animatedSprite.get_animation() != "Run":
		
			body.SnapToGround = false
			body.MaxAirMovement = 120
			body.YSpeed = -400
			$AnimatedSprite.play("FlowerSpring")
			$AnimationPlayer.play("Spring")
			
			body.JumpCheckTime = 0
func _SpringDone():
	$AnimatedSprite.play("default")
	$AnimationPlayer.stop()
	$AnimatedSprite.stop()
