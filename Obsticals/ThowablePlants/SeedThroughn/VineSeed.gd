extends Node2D

var compleate = false

func _ready():
	set_process(false)
	


func _process(delta):
	
	$TheVine/Mask/Head.position.y -= int(round(100*delta))
	$TheVine/Mask/Body.margin_top -= int(round(100*delta))
	


func _on_Head_area_shape_entered(area_id, area, area_shape, self_shape):
	if $TheVine/Mask/Head.global_position.y < global_position.y-20:
		compleate = true
		set_process(false)
		var length =  global_position.y + ($TheVine/Mask/Head.global_position.y-global_position.y)*0.5
		$Vine.global_position.y = length
		$Vine/HitBox.get_shape().set_extents(Vector2(0,length))
		$Vine.GetLadderExtents()
		$Vine.monitoring = true
		
		print($Vine/HitBox.disabled)

func _on_VisibilityEnabler2D_viewport_exited(viewport):
	set_process(false)


func _on_VisibilityEnabler2D_viewport_entered(viewport):
	
	if !compleate && visible:
		$AnimationPlayer.play("SeedOpen")
	
func BeginGrouth():
	if !compleate:
		print("yeahs")
		set_process(true)
		
