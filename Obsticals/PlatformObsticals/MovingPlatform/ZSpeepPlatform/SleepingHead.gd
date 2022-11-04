extends Sprite


const Zs = preload("res://Obsticals/PlatformObsticals/MovingPlatform/ZSpeepPlatform/Z.tscn")


var spawnTime = 2
func _ready():
	set_process(false)

# Called when the node enters the scene tree for the first time.
func _process(delta):
	spawnTime -= 1*delta
	if spawnTime <= 0:
		var Z = Zs.instance()
		add_child(Z)
		Z.global_position = global_position
		spawnTime = 2




func _on_VisibilityNotifier2D_screen_entered():
	set_process(true)


func _on_VisibilityNotifier2D_screen_exited():
	set_process(false)
