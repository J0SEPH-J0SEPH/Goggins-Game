extends Area2D



var GemType = 0

var GemLanch

var Ymomentum = -300

var Gravity = 30

var Xmomentum = 50


var castingdown = true

func _process(delta):
	
	Ymomentum += Gravity
	position.y += Ymomentum*delta
	position.x += Xmomentum*delta
	

	if Ymomentum < 0 && castingdown:
		$DownRayCast.set_cast_to(Vector2(0,-10)) 
		castingdown = false
		
	if Ymomentum > 0 && !castingdown:
		$DownRayCast.set_cast_to(Vector2(0,10)) 
		castingdown = true
		

		
	
	if $HorizontalDirection.is_colliding():
		Xmomentum = 0
		
		
		
	if $DownRayCast.is_colliding():
		Ymomentum = 0
		if castingdown:
			Xmomentum = 0
			set_process(false)
			$HorizontalDirection.enabled = false
			$DownRayCast.enabled = false
		



func _on_Gem_body_entered(body):
	if body.is_in_group("Player"):
		body.Money(GemType+1)
		queue_free()


func _on_VisibilityEnabler2D_screen_exited():
	queue_free()
