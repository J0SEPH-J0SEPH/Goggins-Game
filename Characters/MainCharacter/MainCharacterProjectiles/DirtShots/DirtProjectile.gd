extends Area2D


var Velocity = Vector2()

var Speed = 10

var DirtGravity = 25

var Collided = false

var time = 0.1

func _ready():
	Velocity.y = -Speed
# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	Velocity.y += DirtGravity * delta
	
	if Velocity.y >= 0:
		$AnimatedSprite.flip_v = true
	
	if !Collided:
		translate(Velocity)
	else:
		time -= 1*delta
		$AnimatedSprite.play("hitGround")
		if time <= 0:
			queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Dirt_body_entered(body):
	Collided = true
	


func _on_Dirt_area_entered(area):
	if area.is_in_group("ShovelSwing"):
		
		Speed = 0
		DirtGravity = 5
		if area.ShootingLeft == true:
			rotate(PI*-0.5)
			Velocity.x = 10
		else:
			rotate(PI*0.5)
			Velocity.x = -10
		Velocity.y = -1
		
