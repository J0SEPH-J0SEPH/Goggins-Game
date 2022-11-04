extends Node2D

var Character

var Enterd = false


func _ready():
	set_process(false)

func _process(delta):
	if Input.get_action_strength("Crouch") && !Enterd && Character.CharacterStates == 5:
		
		Enterd = true
		$CannonPlayer.play("CannonEnter")
		Character.CrouchCollider.set_disabled(true)
		Character.CharacterStates = 7
	if Enterd:
		enterCannon()
	
func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		Character = body
		set_process(true)

func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		if !Enterd:
			
			set_process(false)
	

func enterCannon():
	Character.position = lerp(Character.position,$Position2D.global_position,0.4)
	
func ShootPlayer():
	
	Enterd = false
	set_process(false)
	
	if Character.facingLeft:
		if $Sprite.scale.x == -1:
			Character.Anim.scale.x = -1
			Character.facingLeft = false
	else:
		if $Sprite.scale.x == 1:
			Character.Anim.scale.x = 1
			Character.facingLeft = true
			
	$CannonPlayer.play("ShootCannon")
	
	Character.CharacterStates = 11
	Character.Anim.set_offset(Vector2(0,0))
	
func RenableCollider():
	print("donedonedone")
	Character.Collider.set_disabled(false)
	Character.Anim.set_offset(Vector2(0,0))
	Character.CrouchCheckLeft.enabled = false
	Character.CrouchCheckRight.enabled = false
