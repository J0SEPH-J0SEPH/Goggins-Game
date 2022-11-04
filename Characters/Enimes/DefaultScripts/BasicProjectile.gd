extends Node2D


export var Direction = Vector2(0,100)

export var HitMulitpyer = 5

export var FacingLeft = 0 

func _ready():
	set_process(false)

func _process(delta):
	position += Direction * delta
	


func _on_VisibilityEnabler2D_viewport_exited(viewport):
	queue_free()




func _on_VisibilityEnabler2D_viewport_entered(viewport):
	set_process(true)


func _on_Hitpoint_area_entered(area):
	if area.is_in_group("ShovelSwing"):
		if !area.ShootingLeft:
			var newdirection = Vector2(-Direction.y*HitMulitpyer,0)
			Direction = newdirection
			$AnimatedSprite.rotate(PI*0.5)
		else:
			var newdirection = Vector2(Direction.y*HitMulitpyer,0)
			Direction = newdirection
			$AnimatedSprite.rotate(PI*-0.5)
