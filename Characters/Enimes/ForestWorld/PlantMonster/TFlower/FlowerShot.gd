extends Area2D

var Shooter

export var Speed = 100

var SpeedMultipler = 1

var PlayerHit = false

var BigPlantBoss = false

var TimeToFall = 1
	
func _process(delta):
	position.x += Speed*SpeedMultipler*delta
	
	position.y -= cos(position.x*0.05)*200*SpeedMultipler*delta
	
	if BigPlantBoss:
		position.y += 100*delta
		TimeToFall -= 2*delta
		if TimeToFall <= 0:
			BigPlantBoss = false

func _on_VisibilityNotifier2D_screen_exited():
	Shooter.ShotDead()
	queue_free()

export var NewColour = Color.red

func _on_flowerShot_area_entered(area):
	
	if area.is_in_group("ShovelSwing"):
		PlayerHit = true
		modulate = NewColour
		if area.ShootingLeft == true:
			SpeedMultipler = 1.5
		else:
			SpeedMultipler = -1.5


func _on_flowerShot_body_entered(body):
	if body.is_in_group("Player"):
		body.HealthUpdated(EnimeDamage)

export var EnimeDamage = 2


