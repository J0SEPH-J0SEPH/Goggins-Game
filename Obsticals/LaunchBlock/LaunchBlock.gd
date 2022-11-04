extends KinematicBody2D


var ShotPower = 0
var Speed = 500
var Velocity = Vector2(0,0)


func _process(delta):
	
	
	if ShotPower > 0:
		ShotPower -= 1*delta
	else:
		if is_on_floor():
			set_process(false)
			position.x =round(position.x)
			position.y =round(position.y)
			
			print(position.x)
		
	if is_on_wall():
		if is_on_floor():
			set_process(false)
			position.x = round(position.x)
			position.y =round(position.y)
			print(position.x)
		else:
			ShotPower = 0
	
	if !is_on_floor():
		Velocity.y += 200*delta
	
	Velocity.x = ShotPower * Speed
	
	if abs(Velocity.x) < 10:
		Velocity.x = 0
	
	move_and_slide(Velocity,Vector2.DOWN,false,10,60)
	
	


func _on_HitDittect_area_entered(area):
	if area.is_in_group("ShovelSwing"):
		
		ShotPower = 1
		
		
		if area.global_position.x > position.x:
			Speed = -500
		else:
			Speed = 500
		set_process(true)
