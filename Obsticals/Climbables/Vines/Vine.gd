extends Area2D

var Box

var Character

var GrabedVine = false

export var SetCustomOffsetHeight = 0

export var LadderType = 1

export var Hastop = false

var TimeTograb = 1
func _ready():
	GetLadderExtents()
	set_process(false)

func GetLadderExtents():
	Box = $HitBox.get_shape().get_extents()
	
func _process(delta):
	if Input.is_action_pressed("Move_Up") && GrabedVine:
		
		
			
		if round($HitBox.global_position.y-Box.y +32 ) < round(Character.position.y):
			Character.CharacterStates = 12
			Character.LadderExtence = Box.y
			Character.ladderPoss = $HitBox.global_position
			Character.wallJumpValocity = 0
			Character.animatedSprite.set_offset(Vector2(0,0))
			Character.Collider.set_disabled(false)
			Character.CrouchCollider.set_disabled(true)
			Character.ClimbType = LadderType
			GrabedVine = false
			Character.LadderHasTop = Hastop
			Character.SetCustomOffsetHeight = SetCustomOffsetHeight
			
			
	if Input.is_action_pressed("Crouch") && GrabedVine && Hastop && !Input.is_action_pressed("jump"):
		
		if round($HitBox.global_position.y-Box.y +32 ) > round(Character.position.y):
			
			Character.ClimbingOnToladderFroAbove = true
			Character.animatedSprite.play("ClimbingOnToLadderFromAbove")
			Character.CharacterStates = 12
			Character.LadderExtence = Box.y
			Character.ladderPoss = $HitBox.global_position
			Character.wallJumpValocity = 0
			Character.animatedSprite.set_offset(Vector2(0,0))
			Character.Collider.set_disabled(false)
			Character.CrouchCollider.set_disabled(true)
			Character.ClimbType = LadderType
			GrabedVine = false
			Character.LadderHasTop = Hastop
			Character.SetCustomOffsetHeight = SetCustomOffsetHeight
		
	if !GrabedVine:
		if TimeTograb <= 0:
			TimeTograb = 1
			GrabedVine = true
		else:
			TimeTograb -= 1*delta
func _on_Vine_body_entered(body):
	if body.is_in_group("Player"):
		Character = body
		set_process(true)
		GrabedVine = true
func _on_Vine_body_exited(body):
	if body.is_in_group("Player"):
		set_process(false)
		GrabedVine = false



