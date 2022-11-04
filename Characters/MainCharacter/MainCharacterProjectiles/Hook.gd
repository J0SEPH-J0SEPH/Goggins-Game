extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var Player

var Velocity = Vector2()

var Speed = 5

var HookLine

var time = 4
var t = 0


var FacingLeft = false




func _physics_process(delta):
	
	HookLine.set_point_position ( 0, Vector2(Player.position+Vector2(0,-20)))
	HookLine.set_point_position ( 1, Vector2(position))
	
	Velocity.x = Speed  if FacingLeft else -Speed 
	
	if(!FacingLeft):
		$Sprite.scale.x = -1
		$CollisionShape2D.position.x = -7
	
	time -= 10*delta
	if time <= 0:
		t += delta * 0.7
		position = lerp(position,Player.position+Vector2(0,-20),t)
		if t >= 0.3:
			Player.ShotHook = false
			HookLine.queue_free()
			queue_free()
		
	
	translate(Velocity)
	

func _on_Hook_area_entered(body):
	
	if body.is_in_group("HookPoint"):
		Player.SetSwingpoint(body.global_position)
		Player.CharacterStates = 2
		Player.ShotHook = false
		queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
