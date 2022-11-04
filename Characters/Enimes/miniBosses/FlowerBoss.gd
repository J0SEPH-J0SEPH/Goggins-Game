extends Node2D


var CurrentShot

var Shooting = false

var TimeTillShot = 2

const FlowerBall = preload("res://Characters/Enimes/ForestWorld/PlantMonster/TFlower/flowerShot.tscn")

var GroundSmash

var Health = 10

var MaxHealth = 10

var stage 

func _ready():
	stage = get_tree().get_root().get_node("Stage1")
			
func ShotDead():
	CurrentShot = null
	

func _on_VisibilityEnabler2D_screen_entered():
	$AnimationPlayer.play("Flower")
	Health = MaxHealth
	stage.Player.Music.StopPlaying(1)
	
func SpawnEnime():
	$AnimationPlayer.play("GiantPlantMonsterSpawn")
	stage.Player.Music.StartPlaying(2)
	stage.Player.Music.StopPlaying(1)
func StartBattle():
	$AnimationPlayer.play("GiantFlowerMonster")
func CanShoot():
	TimeTillShot -= 1
	if(Health <= MaxHealth*0.5):
		
		var Rand =  round(rand_range(0,2))
		print(Rand)
		if Rand == 0:
			$AnimationPlayer.play("GiantPlantGroundCrush")
		else:
			$AnimationPlayer.play("GiantPlantFireShot")
	else:
		if(!Shooting && TimeTillShot <= 0):
			$AnimationPlayer.play("GiantPlantFireShot")

func Shoot():
	CurrentShot = FlowerBall.instance()
	CurrentShot.BigPlantBoss = true
	get_parent().add_child(CurrentShot)
	CurrentShot.global_position = $ShootPoint.global_position
	CurrentShot.Shooter = self
	
func ShotCompleate():
	TimeTillShot = round(rand_range(3,2))
	$AnimationPlayer.play("GiantFlowerMonster")

	
func TakenDamage(damageDelt : float,Hitter : Node, Attack : String):
	if Attack == "BossProjectile" :
		if Hitter.PlayerHit:
			Health -= 1
			if Health <= 0:
				$AnimationPlayer.play("GiantFlowerDie")
			else:
				$Hit.play("BeenHit")
	if Attack == "DirtProjectile":
		Health -= 1
		if Health <= 0:
			$AnimationPlayer.play("GiantFlowerDie")
			stage.UI.SaveData.PlayerEquips.HasShovel = true
		else:
			$Hit.play("BeenHit")		

var theCamera

func ShakeCamera():
	if theCamera == null:
		theCamera = stage.Playercam
	
	theCamera.ShakeCamera(1,0.5)


func _on_VisibilityEnabler2D_screen_exited():
	$AnimationPlayer.play("Flower")
	stage.Player.Music.StopPlaying(2)
	if stage.Player.Music.LastSongPlayer == 2:
		stage.Player.Music.StartPlaying(1)

func CreatVineSeed():
	$VineSeed.visible = true
	$VineSeed/AnimationPlayer.play("SeedOpen")
	stage.Player.Music.StopPlaying(2)
