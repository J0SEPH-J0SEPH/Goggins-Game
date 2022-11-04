extends Control


var CurrentMenuSetting = 1

func _ready():
	set_process(false)
	
func _process(delta):
	SellectMenu()
	
func SellectMenu():
	if Input.is_action_just_pressed("Crouch"):
		CurrentMenuSetting += 1 if CurrentMenuSetting < 4 else -3
		MoveDownMenu()
	if Input.is_action_just_pressed("Move_Up"):
		CurrentMenuSetting -= 1 if CurrentMenuSetting > 1 else -3
		MoveDownMenu()
		

func MoveDownMenu():
	match CurrentMenuSetting:
		1:
			$Label.text = "\n> Menu <\n\nSettings\n\nMain Menu\n\nQuit Game"
			
			
		2:
			$Label.text = "\nMenu\n\n> Settings <\n\nMain Menu\n\nQuit Game"
		3:
			$Label.text = "\nMenu\n\nSettings\n\n> Main Menu <\n\nQuit Game"
		4:
			$Label.text = "\nMenu\n\nSettings\n\nMain Menu\n\n> Quit Game <"
