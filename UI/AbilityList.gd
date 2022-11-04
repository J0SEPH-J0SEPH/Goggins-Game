extends Control

const Bar = preload("res://UI/PauseScreen/Powers/bar.png")
const UnBar = preload("res://UI/PauseScreen/Powers/unbar.png")
const SelectedBar = preload("res://UI/PauseScreen/Powers/selectedbar.png")
const UnSelectedBar = preload("res://UI/PauseScreen/Powers/unselectedbar.png")

var Dashes = []

var Shovels = []

var FishingRods = []

var Selected = -1

var fildSelected = 0

var Player


func _ready():
	for N in $Dash.get_children():
		if N.visible:
			Dashes.append(N)
	
	for D in $Shovel.get_children():
		if D.visible:
			Shovels.append(D)	
	
	for F in $FishingRod.get_children():
		if F.visible:
			FishingRods.append(F)	
	set_process(false)
	
		
func _process(delta):
	
	
	if Input.is_action_just_pressed("ui_focus_next"):
		Selected += 1
		FindNextBox()
	if Input.is_action_just_pressed("ui_focus_prev"):
		Selected -= 1
		FindLastBox()
	if Input.is_action_just_pressed("UseTool"):
		SelectChoice()
		

var previus

func FindNextBox():
	match fildSelected:
		0:
			if Selected >= Dashes.size():
				fildSelected = 1
				Selected = 0
		1:
			if Selected >= Shovels.size():
				fildSelected = 2
				Selected = 0
		2:
			if Selected >= FishingRods.size():
				fildSelected = 0
				Selected = 0
		
	ColourTab()
		
func FindLastBox():			
	match fildSelected:
		0:
			if Selected < 0:
				fildSelected = 2
				Selected = FishingRods.size()-1
		1:
			if Selected < 0:
				fildSelected = 0
				Selected = Dashes.size()-1
		2:
			if Selected < 0:
				fildSelected = 1
				Selected = Shovels.size()-1
		
	ColourTab()
			
func ColourTab():
	match fildSelected:
		0:
			if previus:
				previus.set("custom_colors/font_color", Color(1,0.8431372549,0.70196078431))
				if !previus.selected:
					previus.get_child(0).texture = UnBar
				else:
					previus.get_child(0).texture = Bar
			Dashes[Selected].set("custom_colors/font_color", Color(1,0.8,0))
			if !Dashes[Selected].selected:
				Dashes[Selected].get_child(0).texture = UnSelectedBar
			else:
				Dashes[Selected].get_child(0).texture = SelectedBar
			previus = Dashes[Selected]
		1:
			if previus:
				previus.set("custom_colors/font_color", Color(1,0.8431372549,0.70196078431))
				if !previus.selected:
					previus.get_child(0).texture = UnBar
				else:
					previus.get_child(0).texture = Bar
			Shovels[Selected].set("custom_colors/font_color", Color(1,0.8,0))
			if !Shovels[Selected].selected:
				Shovels[Selected].get_child(0).texture = UnSelectedBar
			else:
				Shovels[Selected].get_child(0).texture = SelectedBar
				
			previus = Shovels[Selected]
		2:
			if previus:
				previus.set("custom_colors/font_color", Color(1,0.8431372549,0.70196078431))
				if !previus.selected:
					previus.get_child(0).texture = UnBar
				else:
					previus.get_child(0).texture = Bar
			FishingRods[Selected].set("custom_colors/font_color", Color(1,0.8,0))
			if !FishingRods[Selected].selected:
				FishingRods[Selected].get_child(0).texture = UnSelectedBar
			else:
				FishingRods[Selected].get_child(0).texture = SelectedBar
			previus = FishingRods[Selected]
	
func SelectChoice():
	match fildSelected:
		0:
			var Bar = Dashes[Selected].get_child(0)
			var Par = Dashes[Selected]
			Par.Sellected()
			if !Par.selected:
				Bar.texture = UnSelectedBar
			else:
				Bar.texture = SelectedBar
				
		1:
			var Bar = Shovels[Selected].get_child(0)
			var Par = Shovels[Selected]
			Par.Sellected()
			if !Par.selected:
				Bar.texture = UnSelectedBar
			else:
				Bar.texture = SelectedBar
				
		2:
			var Bar = FishingRods[Selected].get_child(0)
			var Par = FishingRods[Selected]
			Par.Sellected()
			if !Par.selected:
				Bar.texture = UnSelectedBar
			else:
				Bar.texture = SelectedBar





func _on_UI_RecivePlayer(p:KinematicBody2D):
	Player = p
	
	for N in $Dash.get_children():
		N.Player = Player 
	
	for D in $Shovel.get_children():
		D.Player = Player 
	
	for F in $FishingRod.get_children():
		F.Player = Player 	
