extends Node2D



func _ready():
	
	TheGame = get_parent()
	
	$ChoiceSelect.SetSaveFiles()
	
	$ChoiceSelect/Selector/poinrer.play("PointerBounce")
	
	$ChoiceSelect/Label.modulate = Color.red
	PreviuseSelected = $ChoiceSelect/Label
	
var Selected = 0

var HorazontalSelect = 0

var fileSelect = 0

var EnteringMenu = false

var inMenu = false
	
var 	PreviuseSelected

var Save1

var Save2

var Save3

var TheGame

func _SetSaveFiles():	
	
	if !$ChoiceSelect.data.GameStarted && !$ChoiceSelect.data2.GameStarted && !$ChoiceSelect.data3.GameStarted:
		$ChoiceSelect/Label.text = "NewGame"
	else:
		$ChoiceSelect/Label.text = "Select Game"
		
	Save1 = 	$ChoiceSelect.data
	Save2 = 	$ChoiceSelect.data2
	Save3 = 	$ChoiceSelect.data3
		
	$ChoiceSelect.save_game(1)
	$ChoiceSelect.save_game(2)
	$ChoiceSelect.save_game(3)
	
	

func _process(delta):
	if !EnteringMenu:
		if !inMenu:
			if Input.is_action_just_pressed("ui_focus_next"):
				Selected += 1
				SelectNextBox()
			if Input.is_action_just_pressed("ui_focus_prev"):
				Selected -= 1
				SelectPrevBox()
			if Input.is_action_just_pressed("UseTool"):
				SelectChoice()
				$ChoiceSelect/Selector/poinrer.play("SelectChoice")
				EnteringMenu = true
	else:
		if inMenu:
			match Selected:
				0:
					if Input.is_action_just_pressed("Pause"):
						$ColorRect/Selector2.visible = false
						HorazontalSelect = 0
						$ColorRect/Selector2.position = Vector2(120,256)
						$PannelSelect.play("CloseSaves")	
						EnteringMenu = false
						$ChoiceSelect/Selector/poinrer.play("PointerBounce")
						fileSelect = 0
						$ColorRect/Selecred.anchor_top = 0.09
						$ColorRect/Selecred.anchor_bottom = 0.31
						
					SelecingFile()
				1:
					
					if Input.is_action_just_pressed("Pause"):
						$PannelSelect.play("CloseSettingsMenu")	
						EnteringMenu = false
						$ChoiceSelect/Selector/poinrer.play("PointerBounce")
						fileSelect = 0
					CurrentSetting()
				2:
					
					if Input.is_action_just_pressed("Pause"):
						$PannelSelect.play("CloseNewSaveGame")	
						Selected = 0
					SettingNewGame()
					
					
func SelectNextBox():
	match Selected:

		1:
			$ChoiceSelect/Selector.position = Vector2(0,32)
			$ChoiceSelect/Label1.modulate = Color.red
			PreviuseSelected.modulate = Color.white
			PreviuseSelected = $ChoiceSelect/Label1
		2:
			$ChoiceSelect/Selector.position = Vector2(0,64)
			$ChoiceSelect/Label2.modulate = Color.red
			PreviuseSelected.modulate = Color.white
			PreviuseSelected = $ChoiceSelect/Label2
		3:
			Selected = 0
			$ChoiceSelect/Selector.position = Vector2(0,0)
			$ChoiceSelect/Label.modulate = Color.red
			PreviuseSelected.modulate = Color.white
			PreviuseSelected = $ChoiceSelect/Label
			
func SelectPrevBox():
	match Selected:

		-1:
			Selected = 2
			$ChoiceSelect/Selector.position = Vector2(0,64)
			$ChoiceSelect/Label2.modulate = Color.red
			PreviuseSelected.modulate = Color.white
			PreviuseSelected = $ChoiceSelect/Label2
		0:
			$ChoiceSelect/Selector.position = Vector2(0,0)
			$ChoiceSelect/Label.modulate = Color.red
			PreviuseSelected.modulate = Color.white
			PreviuseSelected = $ChoiceSelect/Label
		1:
			$ChoiceSelect/Selector.position = Vector2(0,32)
			$ChoiceSelect/Label1.modulate = Color.red
			PreviuseSelected.modulate = Color.white
			PreviuseSelected = $ChoiceSelect/Label1

func isinMenu():
	inMenu = true
	
func notinMenu():
	inMenu = false
		
var Difficultis = ["Effortless","Easy","Normal","Hard","Beyond Hard"]	
			
func SelectChoice():
	match Selected:
		0:
			SetSaveChoices()
			$PannelSelect.play("OpenSaveSlots")
		1:
			$PannelSelect.play("OpenSettingsMenu")
			SettingSelected = 0
			$Settings/Panel/MusicCount.modulate = Color.red
			$Settings/Panel/Music.modulate = Color.red
			$Settings/Panel/SFX.modulate = Color.white
			$Settings/Panel/SFXCount.modulate = Color.white
			$Settings/Panel/FullScreen.modulate = Color.white
			if  OS.window_fullscreen:	
				$Settings/Panel/FullScreen.text = "FullScreen: ON"
			else:
				$Settings/Panel/FullScreen.text = "FullScreen: OFF"
	
		2:
			get_tree().quit()
			
func SetSaveChoices():
	if Save1.GameStarted:
		$ColorRect/NewFile.hide()
	
	if Save2.GameStarted:
		$ColorRect/NewFile2.hide()
		
	if Save3.GameStarted:
		$ColorRect/NewFile3.hide()	
	
	
	$ColorRect/Panel/Health.text = "Health: "+ String( Save1.player.maxhealth)
	$ColorRect/Panel2/Health.text = "Health: "+ String( Save2.player.maxhealth)
	$ColorRect/Panel3/Health.text = "Health: "+ String( Save3.player.maxhealth)
	$ColorRect/Panel/Difficulty.text = "Difficulty: "+ Difficultis[Save1.Difficulty+1]
	$ColorRect/Panel2/Difficulty.text = "Difficulty: "+ Difficultis[Save2.Difficulty+1]
	$ColorRect/Panel3/Difficulty.text = "Difficulty: "+ Difficultis[Save3.Difficulty+1]
	$ColorRect/Selecred.visible = true
	
var Mode = 0


func SelecingFile():
	if Input.is_action_just_pressed("ui_focus_next"):
		fileSelect += 1
		SelectNextFile()
	if Input.is_action_just_pressed("ui_focus_prev"):
		fileSelect -= 1
		SelectPrevFile()
	if Input.is_action_just_pressed("UseTool"):
		match Mode:
			0:
				StartGame()
			1:
				DeleteGame()
				print("deleat")
			2:
				CopyFile()
				print("copy")
		
			
	if fileSelect == 3 && Mode == 0:
		if Input.is_action_just_pressed("Move_Left"):
			HorazontalSelect -= 1
			SelectHorazontalPrevius()
		if Input.is_action_just_pressed("Move_Right"):
			HorazontalSelect += 1
			SelectHorazontalNext()
		
var CopySelected = false

var CopyData = null

func SelectNextFile():
	match fileSelect:

		1:
			$ColorRect/Selecred.anchor_top = 0.34
			$ColorRect/Selecred.anchor_bottom = 0.56
		
		2:
			$ColorRect/Selecred.anchor_top = 0.59
			$ColorRect/Selecred.anchor_bottom = 0.81
	
		3:
			$ColorRect/Selecred.visible = false
			$ColorRect/Selector2.visible = true
			HorazontalSelect = 0
			$ColorRect/Selector2.position = Vector2(120,256)
			
		4:
			$ColorRect/Selecred.visible = true
			$ColorRect/Selector2.visible = false
			fileSelect = 0
			$ColorRect/Selecred.anchor_top = 0.09
			$ColorRect/Selecred.anchor_bottom = 0.31

func SelectPrevFile():
	match fileSelect:

		-1:
			$ColorRect/Selecred.visible = false
			$ColorRect/Selector2.visible = true
			HorazontalSelect = 0
			$ColorRect/Selector2.position = Vector2(120,256)
			fileSelect = 3
			
		0:
			$ColorRect/Selecred.anchor_top = 0.09
			$ColorRect/Selecred.anchor_bottom = 0.31
			
		1:
			$ColorRect/Selecred.anchor_top = 0.34
			$ColorRect/Selecred.anchor_bottom = 0.56
		
			
		2:
			$ColorRect/Selecred.anchor_top = 0.59
			$ColorRect/Selecred.anchor_bottom = 0.81
			$ColorRect/Selecred.visible = true
			$ColorRect/Selector2.visible = false
			

func SelectHorazontalNext():
	match HorazontalSelect:
		1:
			$ColorRect/Selector2.position = Vector2(240,256)
		2:
			$ColorRect/Selector2.position = Vector2(374,256)
		3:
			$ColorRect/Selector2.position = Vector2(120,256)
			HorazontalSelect = 0
	
func SelectHorazontalPrevius():
	match HorazontalSelect:
		-1:
			$ColorRect/Selector2.position = Vector2(374,256)
			HorazontalSelect = 2
		0:
			$ColorRect/Selector2.position = Vector2(120,256)
		1:
			$ColorRect/Selector2.position = Vector2(240,256)
			
			
func DeleteGame():	
	match fileSelect:
		0:
			$ChoiceSelect.reset_data(1)
			$ChoiceSelect.save_game(1)
			Save1 = 	$ChoiceSelect.data
			$ColorRect/NewFile.visible = true
		1:
			$ChoiceSelect.reset_data(2)
			$ChoiceSelect.save_game(2)
			Save2 = 	$ChoiceSelect.data2
			$ColorRect/NewFile2.visible = true
		2:
			$ChoiceSelect.reset_data(3)
			$ChoiceSelect.save_game(3)
			Save3 = 	$ChoiceSelect.data3
			$ColorRect/NewFile3.visible = true
		3:
			$ColorRect/Selector2.visible = false
			fileSelect = 0
			$ColorRect/Selecred.visible = true
			$ColorRect/Selecred.anchor_top = 0.09
			$ColorRect/Selecred.anchor_bottom = 0.31
			$ColorRect/Selecred.modulate = Color.white
			$ColorRect/BottomSelection/Exit.text = "Exit"
			$ColorRect/BottomSelection/Deleat.text = "Delete"
			$ColorRect/BottomSelection/Copy.text = "Copy"
			Mode = 0


func CopyFile():
	match fileSelect:
		0:
			if !CopySelected:
				CopyData = Save1
				CopySelected = true
				$ColorRect/Selecred.modulate = Color.yellow
			else:
				$ChoiceSelect.data = CopyData
				$ChoiceSelect.save_game(1)
				Save1 = CopyData
				SetSaveChoices()
			
				CopySelected = false
				SetCopyCompleate()
		1:
			if !CopySelected:
				CopyData = Save2
				CopySelected = true
				$ColorRect/Selecred.modulate = Color.yellow
			else:
				$ChoiceSelect.data2 = CopyData
				$ChoiceSelect.save_game(2)
				Save2 = CopyData
				SetSaveChoices()
				CopySelected = false
				SetCopyCompleate()
		2:
			if !CopySelected:
				CopyData = Save3
				CopySelected = true
				$ColorRect/Selecred.modulate = Color.yellow
			else:
				$ChoiceSelect.data3 = CopyData
				$ChoiceSelect.save_game(3)
				Save3 = CopyData
				SetSaveChoices()
			
				CopySelected = false
				SetCopyCompleate()
		3:
			SetCopyCompleate()
			
func SetCopyCompleate():
	$ColorRect/Selector2.visible = false
	fileSelect = 0
	$ColorRect/Selecred.visible = true
	$ColorRect/Selecred.anchor_top = 0.09
	$ColorRect/Selecred.anchor_bottom = 0.31
	$ColorRect/Selecred.modulate = Color.white
	$ColorRect/BottomSelection/Exit.text = "Exit"
	$ColorRect/BottomSelection/Deleat.text = "Delete"
	$ColorRect/BottomSelection/Copy.text = "Copy"
	Mode = 0

			
func StartGame():

	match fileSelect:
		0:
			TheGame.CurrentSaveFile = 1
			TheGame.UI.SaveData = Save1

			
			
			if !Save1.GameStarted:
				$PannelSelect.play("OpenNewSaveGame")
				Selected = 2
				print("Save1")
				$CreatNewGame/Panel/Difficulty/Discription.text = ("Not too hard not too easy")
				$CreatNewGame/Panel/Difficulty/Cursor.position = Vector2(256,78)
				$CreatNewGame/Panel/Difficulty.self_modulate = Color.red
				$CreatNewGame/Panel/Difficulty/Selector2.visible = false	
				$CreatNewGame/Panel/Difficulty/Start.modulate = Color.white
				$CreatNewGame/Panel/Difficulty/cancle.modulate = Color.white
				UI = 0
			else:
			
				TheGame.Player.position = Vector2( Save1.player.Xpos,Save1.player.Ypos)
				TheGame.Playercam._set_current(true)  
				set_process(false)
				TheGame.UI.enableHelthBarANDMinimap()
				TheGame.Player.set_physics_process(true)
				TheGame.UI.EnablePausing()
				TheGame.Playercam.EnableFading()
			
		1:
			TheGame.CurrentSaveFile = 2
			TheGame.UI.SaveData = Save2
			TheGame.Player.saveData = Save2
			
			if !Save2.GameStarted:
				$PannelSelect.play("OpenNewSaveGame")
				Selected = 2
				print("Save2")
				$CreatNewGame/Panel/Difficulty/Discription.text = ("Not too hard not too easy")
				$CreatNewGame/Panel/Difficulty/Cursor.position = Vector2(256,78)
				$CreatNewGame/Panel/Difficulty.self_modulate = Color.red
				$CreatNewGame/Panel/Difficulty/Selector2.visible = false	
				$CreatNewGame/Panel/Difficulty/Start.modulate = Color.white
				$CreatNewGame/Panel/Difficulty/cancle.modulate = Color.white
				UI = 0
			else:
				TheGame.Player.position = Vector2( Save2.player.Xpos,Save2.player.Ypos)
				TheGame.Playercam._set_current(true)  
				set_process(false)
				TheGame.UI.enableHelthBarANDMinimap()
				TheGame.Player.set_physics_process(true)
				TheGame.UI.EnablePausing()
				TheGame.Playercam.EnableFading()
			
		2:
			TheGame.CurrentSaveFile = 3
			TheGame.UI.SaveData = Save3
			TheGame.Player.saveData = Save3
			
			if !Save3.GameStarted:
				$PannelSelect.play("OpenNewSaveGame")
				Selected = 2
				$CreatNewGame/Panel/Difficulty/Discription.text = ("Not too hard not too easy")
				$CreatNewGame/Panel/Difficulty/Cursor.position = Vector2(256,78)
				$CreatNewGame/Panel/Difficulty.self_modulate = Color.red
				$CreatNewGame/Panel/Difficulty/Selector2.visible = false	
				$CreatNewGame/Panel/Difficulty/Start.modulate = Color.white
				$CreatNewGame/Panel/Difficulty/cancle.modulate = Color.white
				UI = 0
			else:
			 
				TheGame.Player.position = Vector2( Save3.player.Xpos,Save3.player.Ypos)
				TheGame.Playercam._set_current(true) 
				set_process(false)
				TheGame.UI.enableHelthBarANDMinimap()
				TheGame.Player.set_physics_process(true)
				TheGame.UI.EnablePausing()
				TheGame.Playercam.EnableFading()
			
			
		3:
			if HorazontalSelect == 0:
				$ColorRect/Selector2.visible = false
				HorazontalSelect = 0
				$ColorRect/Selector2.position = Vector2(120,256)
				fileSelect = 0
				$ColorRect/Selecred.anchor_top = 0.09
				$ColorRect/Selecred.anchor_bottom = 0.31
			
				$PannelSelect.play("CloseSaves")	
				EnteringMenu = false
				$ChoiceSelect/Selector/poinrer.play("PointerBounce")	
			if HorazontalSelect == 1:
				$ColorRect/Selector2.visible = false
				fileSelect = 0
				$ColorRect/Selecred.visible = true
				$ColorRect/Selecred.anchor_top = 0.09
				$ColorRect/Selecred.anchor_bottom = 0.31
				$ColorRect/Selecred.modulate = Color.red
				$ColorRect/BottomSelection/Exit.text = "Cancel"
				$ColorRect/BottomSelection/Deleat.text = ""
				$ColorRect/BottomSelection/Copy.text = ""
				Mode = 1
			if HorazontalSelect == 2:
				$ColorRect/Selector2.visible = false
				fileSelect = 0
				$ColorRect/Selecred.visible = true
				$ColorRect/Selecred.anchor_top = 0.09
				$ColorRect/Selecred.anchor_bottom = 0.31
				$ColorRect/Selecred.modulate = Color.green
				$ColorRect/BottomSelection/Exit.text = "Cancel"
				$ColorRect/BottomSelection/Deleat.text = ""
				$ColorRect/BottomSelection/Copy.text = ""
				Mode = 2
		
var MusicVolume = 24
var SFXVolume = 24

var SettingSelected = 0

func CurrentSetting():
	
	if  OS.window_fullscreen:	
		$Settings/Panel/FullScreen.text = "FullScreen: ON"
	else:
		$Settings/Panel/FullScreen.text = "FullScreen: OFF"
	
	
	if Input.is_action_just_pressed("ui_down"):
		SettingSelected += 1
		if SettingSelected >= 3:
			SettingSelected = 0
		SelectedSetting()
		
	if Input.is_action_just_pressed("ui_up"):
		SettingSelected -= 1
		if SettingSelected <= -1:
			SettingSelected = 2
		SelectedSetting()
		
	match SettingSelected:
		0:
			
			if Input.is_action_pressed("Move_Right") && MusicVolume < 37:
				MusicVolume += 1
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), MusicVolume-24)
				SetMusicVolume(false)
				
			if Input.is_action_pressed("Move_Left") && MusicVolume > 3:
				MusicVolume -= 1
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), MusicVolume-24)
				SetMusicVolume(true)
				
		1:
			if Input.is_action_pressed("Move_Right") && SFXVolume < 37:
				SFXVolume += 1
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), SFXVolume-24)
				SetSFXVolume(false)
				
			if Input.is_action_pressed("Move_Left") && SFXVolume > 3:
				SFXVolume -= 1
				AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), SFXVolume-24)
				SetSFXVolume(true)
		2:
			if Input.is_action_just_pressed("UseTool"):
				OS.window_fullscreen = !OS.window_fullscreen
				
func SelectedSetting():
	$Settings/Panel/SFXCount.modulate = Color.white
	$Settings/Panel/Music.modulate = Color.white
	$Settings/Panel/SFX.modulate = Color.white
	$Settings/Panel/MusicCount.modulate = Color.white
	$Settings/Panel/FullScreen.modulate = Color.white
	
	match SettingSelected:
		0:
			$Settings/Panel/MusicCount.modulate = Color.red
			$Settings/Panel/Music.modulate = Color.red
			
		1:
			$Settings/Panel/SFXCount.modulate = Color.red
			$Settings/Panel/SFX.modulate = Color.red
	
		2:
			$Settings/Panel/FullScreen.modulate = Color.red
			
			
func SetMusicVolume(Minus : bool):		
	$Settings/Panel/MusicCount.text[MusicVolume] = "|"
	if Minus:
		$Settings/Panel/MusicCount.text[MusicVolume+1] = "."
	else:
		$Settings/Panel/MusicCount.text[MusicVolume-1] = "."
	
func SetSFXVolume(Minus : bool):		
	$Settings/Panel/SFXCount.text[SFXVolume] = "|"
	if Minus:
		$Settings/Panel/SFXCount.text[SFXVolume+1] = "."
	else:
		$Settings/Panel/SFXCount.text[SFXVolume-1] = "."




		
var Difficulty = 1
	
var UI = 1	
	
func SettingNewGame():
	if UI == 1:
		if Input.is_action_just_pressed("Move_Right"):
			Difficulty += 1 if Difficulty < 3 else 0
			setUIDifficulty()
		if Input.is_action_just_pressed("Move_Left"):	
			Difficulty -= 1 if Difficulty > -1 else 0
			setUIDifficulty()
			
		
	if Input.is_action_just_pressed("ui_down"):
		UI += 1 if UI < 3 else 0
		NewGameUISelect()
		
	if Input.is_action_just_pressed("ui_up"):	
		UI -= 1 if UI > 1 else 0
		NewGameUISelect()
		
	if Input.is_action_just_pressed("UseTool"):
		StartNewGame()
		
func NewGameUISelect():
	match UI:
		1:
			$CreatNewGame/Panel/Difficulty.self_modulate = Color.red
			$CreatNewGame/Panel/Difficulty/Selector2.visible = false	
			$CreatNewGame/Panel/Difficulty/Start.modulate = Color.white
			$CreatNewGame/Panel/Difficulty/cancle.modulate = Color.white
		2:
			$CreatNewGame/Panel/Difficulty.self_modulate = Color.white
			$CreatNewGame/Panel/Difficulty/Selector2.visible = true
			$CreatNewGame/Panel/Difficulty/Selector2.position = Vector2(54,176)
			$CreatNewGame/Panel/Difficulty/Start.modulate = Color.red
			$CreatNewGame/Panel/Difficulty/cancle.modulate = Color.white
		3:
			$CreatNewGame/Panel/Difficulty.self_modulate = Color.white
			$CreatNewGame/Panel/Difficulty/Selector2.visible = true
			$CreatNewGame/Panel/Difficulty/Selector2.position = Vector2(54,206)
			$CreatNewGame/Panel/Difficulty/Start.modulate = Color.white
			$CreatNewGame/Panel/Difficulty/cancle.modulate = Color.red

func StartNewGame():
	match UI:
		1:
			UI += 1 if UI < 3 else 0
			NewGameUISelect() 
		2:
			match fileSelect:
				0:
					TheGame.Player.position = Vector2( Save1.player.Xpos,Save1.player.Ypos)
					TheGame.Playercam._set_current(true)  
					set_process(false)
					TheGame.UI.enableHelthBarANDMinimap()
					TheGame.Player.set_physics_process(true)
					TheGame.UI.EnablePausing()
					Save1.GameStarted = true
					Save1.Difficulty = Difficulty	
					$ChoiceSelect.save_game(1)		
					TheGame.CurrentSaveFile = 1
					TheGame.UI.SaveData = Save1
					TheGame.Player.saveData = Save1
					TheGame.Playercam.EnableFading()
					
				1:
					TheGame.Player.position = Vector2( Save2.player.Xpos,Save2.player.Ypos)
					TheGame.Playercam._set_current(true)  
					set_process(false)
					TheGame.UI.enableHelthBarANDMinimap()
					TheGame.Player.set_physics_process(true)
					TheGame.UI.EnablePausing()
					Save2.GameStarted = true
					Save2.Difficulty = Difficulty	
					$ChoiceSelect.save_game(2)
					TheGame.CurrentSaveFile = 2
					TheGame.UI.SaveData = Save2
					TheGame.Player.saveData = Save2
					TheGame.Playercam.EnableFading()
				2:
					TheGame.Player.position = Vector2( Save3.player.Xpos,Save3.player.Ypos)
					TheGame.Playercam._set_current(true) 
					set_process(false)
					TheGame.UI.enableHelthBarANDMinimap()
					TheGame.Player.set_physics_process(true)
					TheGame.UI.EnablePausing()
					Save3.GameStarted = true
					Save3.Difficulty = Difficulty	
					$ChoiceSelect.save_game(3)
					TheGame.CurrentSaveFile = 3
					TheGame.UI.SaveData = Save3
					TheGame.Player.saveData = Save3
					TheGame.Playercam.EnableFading()
		3:
			$PannelSelect.play("CloseNewSaveGame")	
			Selected = 0
			
func setUIDifficulty():
	match Difficulty:
		-1:
			$CreatNewGame/Panel/Difficulty/Discription.text = ("You are Invinsable however, you will not be able to get the true ending")
			$CreatNewGame/Panel/Difficulty/Cursor.position = Vector2(48,78)
		0:
			$CreatNewGame/Panel/Difficulty/Discription.text = ("Enimes are weaker")
			$CreatNewGame/Panel/Difficulty/Cursor.position = Vector2(152,78)
		1:
			$CreatNewGame/Panel/Difficulty/Discription.text = ("Not too hard not too easy")
			$CreatNewGame/Panel/Difficulty/Cursor.position = Vector2(256,78)
		2:
			$CreatNewGame/Panel/Difficulty/Discription.text = ("Limited lives and enimes are stronger")
			$CreatNewGame/Panel/Difficulty/Cursor.position = Vector2(360,78)
		3:
			$CreatNewGame/Panel/Difficulty/Discription.text = ("You get only one life, no map, Enimes are alot stronger")
			$CreatNewGame/Panel/Difficulty/Cursor.position = Vector2(464,78)
