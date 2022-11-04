extends KinematicBody2D

var velocity = Vector2.ZERO

var Xturn = 0.5

func _ready():
	$AnimatedSprite.play("default")
	$AnimatedSprite.frame = 0
	Xturn = rand_range(-1,1)
func _physics_process(delta):
	
	
	
	velocity.y = -50
	
	
	Xturn += 2*delta
	
	velocity.x = sin(PI*Xturn)*100
	
	position += velocity*delta


func _on_VisibilityNotifier2D_screen_exited():
	get_parent().queue_free()
	
func _on_PlayerDettection_body_entered(body):
	if body.is_in_group("Player"):
		body.SlopeSlide = false


func _on_PlayerDettection_body_exited(body):
	if body.is_in_group("Player"):
		body.SlopeSlide = true
