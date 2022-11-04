extends Control


# Declare member variables here. Examples:
# var a = 2


# Current Save File
var SaveData

var SaveNumber = 1

const FullHealth = preload("res://UI/Health/health.png")
const HalfHealth = preload("res://UI/Health/halfhealth.png")
const EmptuHealth = preload("res://UI/Health/emptyhealth.png")

var MaxHealth = 10

var CurrentHealth = 10

var Health = []

var Player

var Cam

var InItemAquiredMenu = false

onready var Healthbar = $Control/Health

onready var Minimap = $Control/MiniMap

var InPauseMenu = false

# Called when the node enters the scene tree for the first time.

signal ConnectMiniMap()


func _ready():
	GetHealth($Control/Health/HBoxContainer)
	emit_signal("ConnectMiniMap",$Control/MiniMap)
	set_process(false)
	$Pauseing.set_process(false)
	var Stage = get_parent()
	Stage.UI = self
	SaveNumber = Stage.CurrentSaveFile
	

#Turn On HelthbarAndMiniMap------------------------------>
			
func enableHelthBarANDMinimap():
	MoneyGot = int(SaveData.player.Money)
	UpdateMoney(0)
	Healthbar.visible = true
	Minimap.visible = true

#Set the players Position------------------------------>
func SetPlayerPosition():
	Player.position.x = SaveData.player.Xpos
	Player.position.y = SaveData.player.Ypos
	pass
	
func _process(delta):
	
	if InPauseMenu:
		SwitchThroughMenu()
		
	
	if InItemAquiredMenu:
		if Input.is_action_just_pressed("UseTool"):	
			$Pauseing.UnpauseGame()
			$AnimationPlayer.play("ExitItemAquired")
			set_process(false)
			InItemAquiredMenu = false
			
			if SpawnEnimeOnItemAquired:
				EnimeToSpawn.SpawnEnime()
				SpawnEnimeOnItemAquired = false
			
	



#SaveGame------------------------------>
func SaveGame():
	SaveData.player.Xpos = Player.position.x
	SaveData.player.Ypos = Player.position.y
	match SaveNumber:
		1:
			$SaveingAndLoading.data = SaveData
		2:
			$SaveingAndLoading.data2 = SaveData
		3:
			$SaveingAndLoading.data3 = SaveData
	$SaveingAndLoading.save_game(SaveNumber)
	
#Health------------------------------>
func GetHealth(node):
	for N in node.get_children():
		N.name = String( Health.size())
		Health.append(N)
		
		
	MaxHealth = Health.size()*2
	if(CurrentHealth > MaxHealth):
		CurrentHealth = MaxHealth
	
	UpdateHealth()
	
func UpdateHealth():
	for Num in range(CurrentHealth,MaxHealth):
		if(CurrentHealth < 0):
			CurrentHealth = 0
		
		if(CurrentHealth >= 0):
			
			if(CurrentHealth % 2 == 1):
				if(Num == CurrentHealth):	
					Health[Num*0.5].texture = HalfHealth 
				else:
					Health[Num*0.5].texture = EmptuHealth
			else:
				Health[Num*0.5].texture = EmptuHealth
		if(CurrentHealth <= 0):
			if SaveData.PlayerEquips.HasShovel == false:
				Player.tools = 0
				Player.hasShovel = false
				Player.itemCap = 0
			
			emit_signal("Dead")
			$AnimationPlayer.play("Dead")

func Heal():
	for Num in range(0,MaxHealth):
		Health[Num*0.5].texture = FullHealth

var MoneyGot

func UpdateMoney(var NewMoney):
	MoneyGot += NewMoney
	$Control/Health/Cash.text = String(MoneyGot)+"G"
		
#Taking Damage------------------------------>		
func _on_Goggins_PlayerHit(Damage):
	
	var Difficultylevel = int(SaveData.Difficulty)
	
	match Difficultylevel:
		-1:
			#SuperEasy
			pass
		0:
			#Easy
			CurrentHealth -= int(round(Damage*0.5))
			UpdateHealth()
		1:
			#Normal
			CurrentHealth -= Damage
			UpdateHealth()
			
		2:
			#Hard
			CurrentHealth -= Damage
			UpdateHealth()
		3:
			#SuperHard
			CurrentHealth -= int(round(Damage*1.5))
			UpdateHealth()
	
	
	
	
signal Dead()

signal movePlayerBacktoSpawn(Movement)

signal CanPlay()

#Respawning------------------------------>
func Respawn():
	emit_signal("movePlayerBacktoSpawn",Vector2(SaveData.player.Xpos,SaveData.player.Ypos))
	CurrentHealth = MaxHealth
	
	Heal()
	$AnimationPlayer.play("Respawn")
	ResetCamera();
	
func SetCheckpointandSaveGame(CameraAria : Vector2, UpPos : float,leftPos : float):
	SaveData.camera.PositionX = CameraAria.x
	SaveData.camera.PositionY = CameraAria.y
	SaveData.camera.UpPos = UpPos
	SaveData.camera.Left = leftPos
	print(CameraAria.x)
	SaveGame()
	
#Player------------------------------>
func ResetCamera():
		 
		Cam.limit_left =  SaveData.camera.PositionX - SaveData.camera.Left; 
		#Set Cameras Right Limit
		Cam.limit_right = SaveData.camera.PositionX + SaveData.camera.Left;
		#Set Cameras Up Limit
		Cam.limit_top = (SaveData.camera.PositionY) - (SaveData.camera.UpPos);
		#Set Cameras Down Limit
		Cam.limit_bottom =  (SaveData.camera.PositionY) + (SaveData.camera.UpPos); 
		
		Player.CameraAria = Vector2(SaveData.camera.PositionX,SaveData.camera.PositionY)
		Player.leftPos = SaveData.camera.Left;
		Player.UpPos = SaveData.camera.UpPos;
	

func RespawnCompleat():
	emit_signal("CanPlay")



var CurrentMenu = 1

var NewMenu = 1

var Switching = false

func SwitchThroughMenu():
	if Input.is_action_just_pressed("Move_Left"):
		Switching = true
		NewMenu += 1 if NewMenu < 2 else -2
		
		MenuClosed()
	if Input.is_action_just_pressed("Move_Right"):
		Switching = true
		NewMenu -= 1 if NewMenu > 0 else - 2
		
		MenuClosed()
	

func SwitchCompleate():
	if Switching:
		Switching = false
		CurrentMenu = NewMenu
		MenuOpen()
		
		
#Open Pause Screen------------------------------>
func MenuOpen():
	set_process(true)
	InPauseMenu = true
	match CurrentMenu:
		0:
			$Control/ScreenFade/Tapselect.play("ViewAbitiys")
			$Control/ScreenFade/CONTAINERS.set_process(true)
		1:
			$Control/ScreenFade/Tapselect.play("OpenMiniMapMenu")
		2:
			$Control/ScreenFade/Tapselect.play("MenuSettings")
			$Control/ScreenFade/Settings.set_process(true)

func MenuClosed():
	
	InPauseMenu = false
	
	match CurrentMenu:
		0:
			$Control/ScreenFade/Tapselect.play("ExitAbitiys")
			$Control/ScreenFade/CONTAINERS.set_process(false)		
		1:
			$Control/ScreenFade/Tapselect.play("CloseMiniMapMenu")
		2:
			$Control/ScreenFade/Tapselect.play("CloseMenuSettings")
			$Control/ScreenFade/Settings.set_process(false)

func SwitchMenuDown():
	match CurrentMenu:
		0:
			$Control/ScreenFade/Tapselect.play("ViewAbitiys")
			$Control/ScreenFade/CONTAINERS.set_process(true)
			$Control/ScreenFade/Settings.set_process(false)
			$Control/ScreenFade/Tapselect.play("CloseMenuSettings")
		1:
			$Control/ScreenFade/Tapselect.play("ExitAbitiys")
			$Control/ScreenFade/CONTAINERS.set_process(false)		
			$Control/ScreenFade/Tapselect.play("OpenMiniMapMenu")
		2:
			$Control/ScreenFade/Tapselect.play("MenuSettings")
			$Control/ScreenFade/Settings.set_process(true)
			$Control/ScreenFade/Tapselect.play("CloseMiniMapMenu")

func SwitchMenuUp():
	match CurrentMenu:
		0:
			$Control/ScreenFade/Tapselect.play("ViewAbitiys")
			$Control/ScreenFade/CONTAINERS.set_process(true)
			$Control/ScreenFade/Tapselect.play("CloseMiniMapMenu")
		1:
			$Control/ScreenFade/Tapselect.play("OpenMiniMapMenu")
			$Control/ScreenFade/Tapselect.play("CloseMenuSettings")
			$Control/ScreenFade/Settings.set_process(false)
		2:
			$Control/ScreenFade/Tapselect.play("MenuSettings")
			$Control/ScreenFade/Settings.set_process(true)
			$Control/ScreenFade/Tapselect.play("ExitAbitiys")
			$Control/ScreenFade/CONTAINERS.set_process(false)		

			
signal RecivePlayer()

func _on_Goggins_GetPlayer(player: KinematicBody2D):
	Player = player
	
	emit_signal("RecivePlayer",Player)
	
	
	
func EnablePausing():
	$Pauseing.set_process(true)

# Pauseing game------------------------------>
func _on_Pauseing_PauseGame(GamePaused: bool ):
	if GamePaused:
		$AnimationPlayer.play("PauseGame")
	else:
		$AnimationPlayer.play("UnPaused")

# Getting Item game------------------------------>

var SpawnEnimeOnItemAquired = false

var EnimeToSpawn

func _on_Goggins_GotItem(itemID: int,SpawnEnime: bool,Enimetype: Object):
	$Pauseing.PauseGame()
	$AnimationPlayer.play("ItemAquired")
	set_process(true)
	ItemGot(itemID)
	if SpawnEnime:
		
		SpawnEnimeOnItemAquired = true
		EnimeToSpawn = Enimetype
	
func viewingItemGot():
	InItemAquiredMenu = true


func ItemGot(itemID: int):
	match itemID:
		
		1:
			#Shovel
			Player.tools = 1
			Player.hasShovel = true
			Player.itemCap += 1
			$Control/NinePatchRect/Itemname.text = "Shovel Unlocked"
			$Control/NinePatchRect/Description.text = "Press Z to swing the shovel, this can be used to deflect attacks.      Press Z and Up to Shoot while standing on dirt to shoot dirt upwards as an attack"
		2:
			#Dash
			Player.Dash = true
			$Control/NinePatchRect/Itemname.text = "Dash Unlocked"
			$Control/NinePatchRect/Description.text = "Thanks for playing this is all that has been added for now, Let me know how the experiance was. you can use the dash by pressing C"
