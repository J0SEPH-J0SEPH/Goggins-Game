extends Area2D


export var MaxHealth = 2

var Dead = false

export var Health = 2

	

export var AmountOfWeaknesses = 0

export var Weakness = ["Weakness","Weakness2"]


func _on_Hitpoint_area_entered(area):
	if !Dead:
		if AmountOfWeaknesses > 0:
			for weak in Weakness:
				if area.is_in_group(weak):
					Attacked()
						
		else:
			print(invincable,"duadfhasjfhdsj")
			if area.is_in_group("PlayerAttack") && !invincable:
				Attacked()
				

func Attacked():
	Health -= 1
	if Health <= 0:
		$AnimationPlayer.play("dead")
		Dead = true
	else:
		$AnimationPlayer.play("Attacked")
		invincable = true
		print("hit")
		
var invincable = false	
		
func InvinsableFrames():
	invincable = false
