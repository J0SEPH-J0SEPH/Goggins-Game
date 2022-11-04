extends Node

export var NewPoint = Vector2(0,0)

var Player

func _ready():
	set_process(false)

func _process(delta):

	if Input.is_action_just_released("Move_Up") && Player.CharacterStates == 1:
		$DoorSprite.play("DoorOpen")
		Player.newDoorPos = NewPoint
		Player.CharacterStates = 13


func _on_Door_body_entered(body):
	if body.is_in_group("Player"):
		Player = body
		set_process(true)
		

func _on_Door_body_exited(body):
	if body.is_in_group("Player"):
		set_process(false)
