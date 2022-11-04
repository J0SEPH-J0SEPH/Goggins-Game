extends Node2D


export var OnRoof = false

var Health = 3


				
func ChangeSprite():
	match Health:
		2:
			$SpriteHolder/Sprite2.visible = true
			$SpriteHolder/Sprite1.visible = false
			$RockHit.ShootGems()
		1:
			$SpriteHolder/Sprite2.visible = false
			$SpriteHolder/Sprite3.visible = true
			$RockHit.ShootGems()
		0:
			$HitRock.play("Destroyed")
			$RockHit.ShootGems()
		-1:
			queue_free()


func _on_RockHit_area_entered(area):
	if area.is_in_group("ShovelSwing"):
		Health -= 1
		if Health < -1:
			Health = -1
		
		if OnRoof:
			$HitRock.play("HitWall")
		else:
		
			if area.ShootingLeft == true:
				$HitRock.play("HitLeft")
			else:
				$HitRock.play("HitRight")
