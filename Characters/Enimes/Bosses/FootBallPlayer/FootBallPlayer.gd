extends KinematicBody2D


var Pos 
export var StartDirectionFacingLeft = true

func _ready():
	set_physics_process(false)
	Pos = position
	$AnimationPlayer.stop(true)

func _on_VisibilityEnabler2D_screen_entered():
	$AnimationPlayer.play("Still")
	

var Player

var CurrentMove = 1

var Speed = 0

var YSpeed = 0

var inBattle = false

var velocity = Vector2.ZERO

const FLOOR_Normal = Vector2.UP

var HitWall = false

var WallHitTime = 0.5

const FootBall = preload("res://Characters/Enimes/Bosses/FootBallPlayer/FootBallProjectile/FootBall.tscn")


func BeginFight(thePlayer : Node2D):
	
	inBattle = true
	Player = thePlayer
	CheckDirection()
var BossRestime = 1	
	
func RestTime():
	if inBattle && !dead:
		Speed = 0
		BossRestime -= 1
		if BossRestime <= 0:
			CurrentMove = int(rand_range(0,4))
			if CurrentMove == 2 && !canShootFootBall:
				CurrentMove = 3
			
			set_physics_process(true)
		else:
			$AnimationPlayer.play("Still")
			


		
var theCamera
		
func _physics_process(delta):
	
	if !is_on_floor():
		YSpeed += 600*delta
		
	match CurrentMove:
		1:
	
			if !HitWall:
				$AnimationPlayer.play("Charging")
				if FacingLeft:
					if Speed > -200:
						Speed -= 100*delta
				else:
					if Speed < 200:
						Speed += 100*delta
				
				$Hitpoint.position.x = -5 if FacingLeft else 5
				$WallDetect.enabled = true
			if $WallDetect.is_colliding():
				
				$WallDetect.enabled = false
				
				if theCamera == null:
					theCamera = get_tree().get_root().get_node("Stage1").Playercam
	
				theCamera.ShakeCamera(1,0.5)
				
				if FacingLeft:
					Speed = 100
				else:
					Speed = -100
				YSpeed = -200
				HitWall = true
				WallHitTime = 0.5
				
			
				
			if HitWall:
				WallHitTime -= 1* delta
				
				
				
				if WallHitTime <= 0 && is_on_floor():	
					BossRestime = int(rand_range(3,5))
					set_physics_process(false)
					CheckDirection()
					HitWall = false
					$Hitpoint.scale.y = 0.93
					$Hitpoint.position.x = 0
		2:
			Speed = 0
			$AnimationPlayer.play("KickBall")
			
		3:
			
			if Jumped:
				WallHitTime -= 3* delta
				if is_on_floor() && WallHitTime < 0:
					BossRestime = int(rand_range(3,5))
					set_physics_process(false)
					CheckDirection()
					Jumped = false
			else:
				Speed = 0
				$AnimationPlayer.play("Jump")	
			
	velocity = Vector2(Speed,YSpeed)
	
	velocity = move_and_slide(velocity,FLOOR_Normal)

func KickCompleat():
	BossRestime = int(rand_range(5,7))
	set_physics_process(false)
	CheckDirection()

var FacingLeft = true

var Jumped = false

func Jump():
	WallHitTime = 0.5
	YSpeed = -300
	Jumped = true
	if FacingLeft:
		Speed = -100
	else:
		Speed = 100
func CheckDirection():
	
	
	if FacingLeft:
		if Player.global_position.x >  global_position.x:
			$AnimationPlayer.play("TurnAround")	
			return
		else:
			RestTime()
			return
	else:	
		
		if Player.global_position.x < global_position.x:
			$AnimationPlayer.play("TurnAround")	
			return
		else:
			RestTime()
			return
func Flip():
	$FootBallSpawnPoint.position.x = -$FootBallSpawnPoint.position.x
	$Sprite.scale.x = -$Sprite.scale.x
	if FacingLeft:
		FacingLeft = false
		$WallDetect.set_cast_to(Vector2(29,0))
	else:
		FacingLeft = true
		$WallDetect.set_cast_to(Vector2(-29,0))
var health = 7

var maxhealth = 7

var canShootFootBall = true

var CurrentShot

func KickFootBall():
	canShootFootBall = false
	CurrentShot = FootBall.instance()
	get_parent().add_child(CurrentShot)
	CurrentShot.global_position = $FootBallSpawnPoint.global_position
	if (!FacingLeft):
		CurrentShot.SwitchDirections()
		
	


func TakenDamage(DamageDelt: int,Attacker: Node2D,AttackType : String):
	if AttackType == "BossProjectile":
		if Attacker.PlayersBall:
			health -= DamageDelt
			Attacker.queue_free()
			canShootFootBall = true
			
			if health <= 0:
				inBattle = false
				$AnimationPlayer.stop(true)
				$Hitpoint.dead = true
				set_physics_process(false)
				Speed = 0
				YSpeed = 0
				$HitAnim.play("Dead")
				dead = true
			else:
				$HitAnim.play("Hit")
				
				
const DashAbility = preload("res://Collectables/KeyCollectobles/Dash/DashItemPickup.tscn")
	
	
var dead = false
			
func Dead():
	get_parent().BossDefeated()
	var dash = DashAbility.instance()
	get_parent().add_child(dash)
	dash.global_position = Vector2( global_position.x, -2200)
	
	queue_free()

func _on_VisibilityEnabler2D_screen_exited():
	set_physics_process(false)
	$AnimationPlayer.stop(true)
	canShootFootBall = true
	position = Pos
	inBattle = false
	health = maxhealth
	if StartDirectionFacingLeft && !FacingLeft:
		$FootBallSpawnPoint.position.x = -$FootBallSpawnPoint.position.x
		$Sprite.scale.x = -$Sprite.scale.x
		FacingLeft = true
