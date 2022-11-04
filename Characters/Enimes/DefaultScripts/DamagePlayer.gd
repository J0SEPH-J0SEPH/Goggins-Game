extends Node

var dead = false

var player

export var EnimeDamage = 2

var PlayerIn = false

func Dead():
	 dead = true
	
func _ready():
	set_process(false)
	
	
func _process(delta):
	
	if !dead:
		
		player.HealthUpdated(EnimeDamage)
	else:
		set_process(false)

func _on_Hitpoint_body_entered(body):
	if body.is_in_group("Player") && !dead:
		body.HealthUpdated(EnimeDamage)
		player = body
		set_process(true)

func _on_Hitpoint_body_exited(body):
	set_process(false)



