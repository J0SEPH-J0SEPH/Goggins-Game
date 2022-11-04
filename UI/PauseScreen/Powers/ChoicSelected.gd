extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var Abbility = 0

var selected = true

var Player
# Called when the node enters the scene tree for the first time.

func _ready():
	Player = get_parent().get_parent().get_parent().get_parent().get_parent().Player
	
func Sellected():
	selected = !selected
	if selected :
		setAbility()
	else:
		DeselectAbility()
		
func setAbility():
	match Abbility:
		0:
			if(Player != null):
				Player.Dash = true
			else:
				print ("hu")	
		1:
			Player.PowerDash = true
				
		2:
			Player.ChargeBoost= true
		3:
			Player.DoubleDash = true
		4:
			Player.AquaSkim = true
		5:
			Player.BlastBelt = true	
		
			
			
func DeselectAbility():
	match Abbility:
		0:
			if(Player != null):
				Player.Dash = false
			else:
				print ("hu")	
		1:
			Player.PowerDash = false
				
		2:
			Player.ChargeBoost= false
		3:
			Player.DoubleDash = false
		4:
			Player.AquaSkim = false
		5:
			Player.BlastBelt = false
			

func _on_UI_RecivePlayer(P: KinematicBody2D):
	Player = P
