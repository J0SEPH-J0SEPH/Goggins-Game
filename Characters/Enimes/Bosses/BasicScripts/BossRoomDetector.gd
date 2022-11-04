extends Node2D


var Player
var InbossBattle = false

var isbossDead = false

var TopNode

func _ready():
	TopNode = get_tree().get_root().get_node("Stage1")
	

func _on_EnterdRoom_body_entered(body):
	if body.is_in_group("Player") && !InbossBattle && !isbossDead:
		Player = body
		InbossBattle = true
		
		$Door/Doors.play("DoorClose") 
		

func BeginBossBattle():
	$Boss.BeginFight(Player)
	TopNode.Player.Music.StartPlaying(2)
	

func _on_VisibilityNotifier2D_screen_exited():
	InbossBattle = false
	if !isbossDead:
		TopNode.Player.Music.StopPlaying(2)
		TopNode.Player.Music.StartPlaying(1)
	if !isbossDead:
		$Door/Doors.play("DoorOpen") 

func BossDefeated():
	isbossDead = true
	$Door/Doors.play("DoorOpen") 
	TopNode.Player.Music.StopPlaying(2)
	TopNode.Player.Music.StartPlaying(1)
