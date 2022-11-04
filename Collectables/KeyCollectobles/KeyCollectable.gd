extends Node


export var ItemID = 0


export var SpawnEnime = false

var EnimeToSpawn

var UI

var saveGame
		
var GotItem = false

func _on_ItemPickup_body_entered(body):
	if body.is_in_group("Player") && !GotItem:
		body.gotItem(ItemID,SpawnEnime,EnimeToSpawn)
		$AnimatedSprite.visible = false
		$CollisionShape2D.disabled = true
		GotItem = true

func _on_VisibilityNotifier2D_screen_entered():
	if SpawnEnime:
		EnimeToSpawn = get_parent()
	
	saveGame = get_tree().get_root().get_node("Stage1").UI
	
	match ItemID:
		1:
			if saveGame.SaveData.PlayerEquips.HasShovel == false:
				$CollisionShape2D.disabled = false
				GotItem = false
				$AnimatedSprite.visible = true
				
		2:
			if saveGame.SaveData.PlayerEquips.HasDash == false:
				$CollisionShape2D.disabled = false
				GotItem = false
				$AnimatedSprite.visible = true
				saveGame.SaveData.PlayerEquips.HasDash = true
