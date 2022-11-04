extends Area2D

var Health = 10

var distance = 0

var headingbackup = false
# Called when the node enters the scene tree for the first time.
func _process(delta):
	if(position.y < distance && !headingbackup):
		position-= Vector2.UP*200*delta
		
	if(position.y >= distance):
		headingbackup = true
	
	if headingbackup:
		$Anim.play("GoBackUp")	
		position += Vector2.UP*150*delta
		if(position.y <= 0):
			position.y = 0
			$Anim.play("Attack")	
			headingbackup = false
			set_process(false)
			
			
func BeenHit():
	Health -= 1
	
	
	if Health <= 0:
		var Parent = get_parent()
		Parent.queue_free()
