extends Node2D


const Gems = preload("res://Collectables/GenrileCollectables/Money/Gems/GemPhysics.tscn")

var Amount

export var GemTypes = [1, 2, 3, 4]


var Current = 0
func ShootGems():
	for gemType in range(GemTypes.size()):
		
		var Gem = Gems.instance()
		get_parent().get_parent().add_child(Gem)
		Gem.global_position = global_position
		
		Gem.GemType = gemType
		Gem.Xmomentum = rand_range(-20,20)
		Gem.Ymomentum = rand_range(-300,-500)

