extends KinematicBody2D


var saveData

const FLOOR_Normal = Vector2.UP

const SNAP_DIRECTION = Vector2.DOWN

const SNAP_LENGTH = 8

var SnapVector = SNAP_DIRECTION*SNAP_LENGTH

const FLOOR_MAX_ANGLE = deg2rad(50)



var velocity = Vector2()

var Speed = 0.0

var YSpeed = 0.0

var MaxAirMovement = 20.0

var MaxAirMovementFromStandStill = 70

#Sliddy ness   Useful for slighdy platforms
var MoveDamping = 0.5

var AirMoveDamping = 0.3

var JumpPower = 250.0

var facingLeft = true

var SnapToGround = true

var JumpCheckTime = 0

var CharacterStates = 7

var ClimbType = 1
var LadderExtence = 1
var ladderPoss

var FallingThroughGround = false

# ItemsAquired

# DashAbilitys
var Dash = true
var PowerDash = false
var DoubleDash = false
var AquaSkim = false
var BlastBelt = false
var ChargeBoost = false
var PhantomBoost = false
var GotSuperSpin = false

# Checkifplayerisdoneturning
var TurnCompleat = true


var Anim
var CrouchCollider
var Collider
var inputsX
var Music
var UI

var gravity = 600

#Turn Off for moving platforms
var SlopeSlide = true

signal GetPlayer()

func _ready():
	
	set_physics_process(false)
	
	emit_signal("GetPlayer",self)
	
	var Stage = get_parent()
	Stage.Player = self
	Stage.Playercam = $Camera2D
	
	CrouchCollider = $CollisionCrouched
	Collider = $CollisionShape2D
	Anim = $AnimatedSprite
	Music = $Music
	UI = get_tree().get_root().get_node("Stage1").UI

#Update Function ---------------------------->

func _physics_process(delta):
	
	
	
		
	
	#Handle Horizontal Movement
	if !(ToolInuse):
		inputsX = Input.get_action_strength("Move_Right") - Input.get_action_strength("Move_Left");
	
	
	match CharacterStates:
		# Standerd Movement
		1:
			
			#Animations
			HanldeAnimations()
			
			#Movement
			NotPerformingAnyAction(inputsX,delta)
			
			#Tools
			Tool(inputsX, delta)
			
			#walljumping
			Update_Wall_Direction()
			
			#TimeToStopbeingonwall
			WallJumpTimer = 0.3
		# Swinging
		2:
			Swinging(delta,inputsX)
		3:
			HandleWallSliding(delta, inputsX)
			$AnimatedSprite.play("WallSliding")
			
			#walljumping
			Update_Wall_Direction()
		4:
			 Dashing(delta,inputsX)
		
		5:
			#Crouching
			Crouching(delta,600,inputsX)
			CrouchTool()
		6:
			#BlowTorchHover
			 BlowTorchDown(delta)
		7:
			#Stop
			YSpeed = 0
			Speed = 0
		8:
			#WallSpinning
			SuperSpin(delta, inputsX)
			
			#walljumping
			Update_Wall_Direction()
		9:
			#ChargeDashing
			ChargeDashing(delta,inputsX)
		10:
			#ZipWireing
			pass
		11:
			#MegaBlast	
			MegaBlast(delta)
		12:
			#Climbing
			Climbing()
		13:
			#EnterDoor
			Enteringdoor(newDoorPos)
	#velocity.x = Speed if abs(Speed) > 20 else 0
	
	
	velocity.x = Speed + wallJumpValocity
	
	
	
	
	if CharacterStates == 8:
		velocity.x = max(velocity.x,-MaxAirMovement)
		velocity.x = min(velocity.x,MaxAirMovement)
		

	
		
	velocity.y = YSpeed
		

	if(SnapToGround):
		velocity.y = move_and_slide_with_snap(velocity,SnapVector  ,FLOOR_Normal,SlopeSlide,4,FLOOR_MAX_ANGLE).y
	else:
		velocity = move_and_slide(velocity,FLOOR_Normal)
	
	
	
		
#Default Actions ------------------------------------------>

func NotPerformingAnyAction(inputsX: float,delta: float):
	Horizontal_Movement(inputsX,delta)
	VerticalMovement(delta,600)
	
	
	
func Horizontal_Movement(inputsX: float,delta: float):
	
	#fallThroughPlatforms
	if FallingThroughGround:
		if Input.is_action_just_released("Crouch"):
			set_collision_mask_bit(9, true)
			FallingThroughGround = false
	
	#set ground movement
	if is_on_floor():
		
		#fallThroughPlatforms
		if Input.is_action_just_pressed("Crouch"):
			set_collision_mask_bit(9, false)
			FallingThroughGround = true
		
		
		
		
		#handleCrouching
		if Input.is_action_pressed("Crouch"):
			
		
			
			CharacterStates = 5
			$AnimatedSprite.play("BeginCrouch")
			$AnimatedSprite.set_offset(Vector2(0,2))
			$CollisionShape2D.set_disabled(true)
			$CollisionCrouched.set_disabled(false)
		elif FallingThroughGround:
			set_collision_mask_bit(9, true)
			FallingThroughGround = false
		#handleDash
		if(Input.is_action_just_pressed("Dash") && Dash && !Input.is_action_just_pressed("jump")):
			HitWall = false
			CharacterStates = 4
			DashTime = 2
			CreatGhostFrame = 1.8
			$AnimatedSprite.play("Dashing")
			
			if facingLeft:
				$AnimatedSprite/HitColliders/DashCollshion/CollisionShape2D.position = Vector2(6,-13)
			else:
				$AnimatedSprite/HitColliders/DashCollshion/CollisionShape2D.position = Vector2(-6,-13)
			
			$AnimatedSprite/HitColliders/DashCollshion/CollisionShape2D.set_disabled(false)
					
			Dashing = true
			
			if PowerDash:
				DashPower()
		#SetDirectionFacing
		if CharacterStates != 4 && !Digging:
			if inputsX > 0 && !facingLeft:
				$AnimatedSprite.scale.x = 1
				$AnimatedSprite.play("Turning")
				TurnCompleat = false
				facingLeft = true
				MaxAirMovement = 70
			if inputsX < 0 && facingLeft:
				$AnimatedSprite.scale.x = -1
				$AnimatedSprite.play("Turning")
				TurnCompleat = false
				facingLeft = false
				MaxAirMovement = 70
		
		#SetMovingSpeed
		Speed += 900 * (inputsX)* delta
		Speed *= pow(1.0 - MoveDamping, delta*10)
		
		#WallJumpSpeed
		wallJumpValocity = 0
		
		if (ChargeBoosted):
			$AnimatedSprite.modulate = Color.white
			ChargeBoosted = false
	#set Air movement
	else:
		wallJumpValocity = lerp(wallJumpValocity, 0, 0.1)
			
		
		Speed += 900 * (inputsX) *delta
		Speed *= pow(1.0 - AirMoveDamping, delta*10)
		Speed = max(Speed,-abs(MaxAirMovement))
		Speed = min(Speed,abs(MaxAirMovement))
		
		#MegaChargeBoosted
		if Input.is_action_just_pressed("Dash") && ChargeBoosted:
			CharacterStates = 11
			Charge = 0
		
	if abs(inputsX) < 0.1 && abs(Speed) < 30:
		Speed = 0
	
	if(is_on_wall()):
		
		SnapToGround = false
		MaxAirMovement = 90
		

func VerticalMovement(delta: float,MaxfallSpeed: float):
	
	#Handle Gravity
	if(!is_on_floor()):
		YSpeed += gravity * delta
		YSpeed = clamp(YSpeed,-10000,MaxfallSpeed)
		JumpCheckTime -= 1 * delta
		if Input.is_action_just_pressed("jump"):
			JumpCheckTime = 0.2
		
	else:
		SnapToGround = true
		YSpeed = 0
		
	#bumpHeadOnceling	
	if (is_on_ceiling() && YSpeed < 0 ):
		YSpeed = 0
	
	#Small jump
	if Input.is_action_just_released("jump") && velocity.y < -50 && !Dashing && gravity > 0:
		YSpeed = -50
	
	#Spin jump	
	if !is_on_floor() && velocity.y < 60 && Input.is_action_just_pressed("jump") && wallJumpValocity == 0:
		
		if abs(Speed) >= 70  && (inputsX > 0 && facingLeft  || inputsX < 0 && !facingLeft):
			
			if($AnimatedSprite.get_animation() == "Falling" || $AnimatedSprite.get_animation() == "Jump"):
				if MaxAirMovement < 250:
					MaxAirMovement = 250
				
				if facingLeft:
					Speed += 100
				else: 
					Speed -= 100
				$AnimatedSprite.play("SpinnJump")
	
	#CheckIfCanJump
	if (Input.is_action_just_pressed("jump") || JumpCheckTime > 0)&& is_on_floor() &&  !Input.is_action_pressed("Dash"):
		SnapToGround = false
		YSpeed = -JumpPower
		JumpCheckTime = 0
		MaxAirMovement = abs(Speed) if abs(Speed) > MaxAirMovementFromStandStill else MaxAirMovementFromStandStill
	

onready var CrouchCheckLeft = $CollisionCrouched/LeftUpCheck
onready var CrouchCheckRight = $CollisionCrouched/RightUpCheck

#Crouching ------------------------------------->
var CannotUnCrouch = false
var CrouchTurn = false


func Crouching(delta : float,MaxfallSpeed : float, inputsX: float):
	
	
	
	
	
	if(CrouchTurn):
		if $AnimatedSprite.get_frame() == 1:
			CrouchTurn = false
	#SetMovingSpeed
	Speed += 700 * (inputsX)* delta
	Speed *= pow(1.0 - MoveDamping, delta*10)
		
		
	if(!is_on_floor()):
		
		#CrouchAnimations
		if(YSpeed > 0 && !ToolInuse):
			$AnimatedSprite.play("CrouchFall")
		
		#Crouch Gravity	
		YSpeed += gravity * delta
		YSpeed = clamp(YSpeed,-1000,MaxfallSpeed)
		JumpCheckTime -= 1 * delta
		if Input.is_action_just_pressed("jump"):
			JumpCheckTime = 0.2
		
	else:
		SnapToGround = true
		YSpeed = 5
		if (Input.is_action_pressed("Crouch") || CannotUnCrouch) && !CrouchTurn && !ToolInuse:
			
			if(abs(Speed) < 20 || is_on_wall()):
				$AnimatedSprite.play("Crouching")
			else:
				$AnimatedSprite.play("CrouchRun")
		
			#SetDirectionFacing
	
		if inputsX > 0 && !facingLeft:
			$AnimatedSprite.scale.x = 1
			$AnimatedSprite.play("CrouchingTurn")
			CrouchTurn = true
			TurnCompleat = false
			facingLeft = true
			MaxAirMovement = 70
		if inputsX < 0 && facingLeft:
			$AnimatedSprite.scale.x = -1
			$AnimatedSprite.play("CrouchingTurn")
			
			CrouchTurn = true
			TurnCompleat = false
			facingLeft = false
			MaxAirMovement = 70
			
	#bumpHeadOnceling	
	if (is_on_ceiling() && YSpeed < 0):
		YSpeed = 0
	
	#Small jump
	if Input.is_action_just_released("jump") && velocity.y < -50:
		YSpeed = -50
	
	#CheckIfCanJump
	if (Input.is_action_just_pressed("jump") || JumpCheckTime > 0)&& is_on_floor():
		
		$AnimatedSprite.play("CrouchJump")
		
		SnapToGround = false
		YSpeed = -JumpPower*0.8
		JumpCheckTime = 0
		MaxAirMovement = abs(Speed) if abs(Speed) > MaxAirMovementFromStandStill else MaxAirMovementFromStandStill
	
	if !Input.is_action_pressed("Crouch") && !ToolInuse:
		CrouchCheckLeft.enabled = true
		CrouchCheckRight.enabled = true
		if !CrouchCheckLeft.is_colliding() && !CrouchCheckRight.is_colliding():
			CannotUnCrouch = false
			$AnimatedSprite.play("CrouchGetUp")
			if $AnimatedSprite.get_frame() == 2:
				CharacterStates = 1
				$CollisionShape2D.set_disabled(false)
				$CollisionCrouched.set_disabled(true)
				$AnimatedSprite.set_offset(Vector2(0,0))
				CrouchCheckLeft.enabled = false
				CrouchCheckRight.enabled = false
		else:
			CannotUnCrouch = true
		
#Dashing ----------------------------------------->

var Dashing = false

var DashTime = 2

var CreatGhostFrame = 1.8

var HitWall = false

var PastXpos = 0

const DahsBall = preload("res://Characters/MainCharacter/MainCharacterProjectiles/DashBoosts/DashBall1.tscn")

const DoubleDashBall = preload("res://Characters/MainCharacter/MainCharacterProjectiles/DashBoosts/DashBall2.tscn")

const PhantomDashBall = preload("res://Characters/MainCharacter/MainCharacterProjectiles/DashBoosts/PhantomDashBall2.tscn")

const BlastDashBall = preload("res://Characters/MainCharacter/MainCharacterProjectiles/DashBoosts/DashBall3.tscn")

const PhantomBlastDashBall = preload("res://Characters/MainCharacter/MainCharacterProjectiles/DashBoosts/PhantomDashBall3.tscn")

const PhantomDashProjectile = preload("res://Characters/MainCharacter/MainCharacterProjectiles/DashBoosts/BlastProjectile/PhantomDashProjectile.tscn")

const SpeedSprite = preload("res://Characters/MainCharacter/MainCharacterProjectiles/PlayerSprite/PlayerSprite.tscn")

func Dashing(delta: float,inputsX : float):
	
	#Dash Duration
	DashTime -= 4*delta
	
	#Dash Up Slopes
	SnapToGround = false
	
	if(!HitWall):
		MaxAirMovement = 150
	
	
	#Ramp Momentum
	var rot = get_floor_normal()
	
	
	if(is_on_floor() && (facingLeft && rot.x < 0 || !facingLeft && rot.x > 0)):
		
		YSpeed = (1+rot.y)*-800
		
	if !is_on_floor():
		YSpeed += gravity * 0.5 * delta
		YSpeed = clamp(YSpeed,-1000,600)
		JumpCheckTime -= 1 * delta
		if Input.is_action_just_pressed("jump"):
			JumpCheckTime = 0.2
	
	
	
		
	if(!HitWall):
		
		#Set GhostFrames
		if PhantomBoost:
			if 	DashTime < CreatGhostFrame:
				GhostFrames()
				CreatGhostFrame -= 0.3
		
		
		if Input.is_action_just_pressed("jump") && is_on_floor():
			YSpeed = -JumpPower*0.7
			
		
		
		if(DashTime <= 0):
			
			if !ChargeBoost:
				CharacterStates = 1
				Dashing = false
				$AnimatedSprite/HitColliders/DashCollshion/CollisionShape2D.set_disabled(true)
			
			else:
				CharacterStates = 9
				
			if(DashPower != null):
				DashPower.queue_free()
				DashPower = null
				
			if(BlastBelt && PowerDash):
				if PhantomBoost:
					var Projectile = PhantomDashProjectile.instance()
					get_parent().add_child(Projectile)
					if(!facingLeft):
						Projectile.position = global_position+ Vector2(-3,-12)
						Projectile.scale.x = -1
					else:
						Projectile.position =  global_position+Vector2(3,-12)
					
		if(facingLeft):
			Speed = 200 + (inputsX*50)
		else:
			Speed = -200 + (inputsX*50)
	
	if( is_on_wall()):
		HitWall = true
		
		Dashing = false
		$AnimatedSprite/HitColliders/DashCollshion/CollisionShape2D.set_disabled(true)
		if(DashPower != null):	
			DashPower.queue_free()
			DashPower = null
		$AnimatedSprite.play("WallHit")
		if(facingLeft):
			Speed = -150
			YSpeed = -100
		else:
			Speed = 150
			YSpeed = -100
	
	if HitWall:
		
		
		if ($AnimatedSprite.get_frame() == 4 || round(position.x) == PastXpos ):
			MaxAirMovement = 60
			
			CharacterStates = 1
			$AnimatedSprite.play("Run")
		PastXpos = round(position.x) 

var DashPower

func GhostFrames():
	var Sp = SpeedSprite.instance()
	get_parent().add_child(Sp)
	Sp.position = position + Vector2(0,-16)
	if !facingLeft:
		Sp.scale.x = -1
	Sp.texture = $AnimatedSprite.get_sprite_frames().get_frame( $AnimatedSprite.get_animation() ,  $AnimatedSprite.get_frame()) 
	Sp.get_node('Anim').play("SpriteDie")

export var PhantomBoostColour = Color(0,0,0)

func DashPower():
	
	if DoubleDash:
		if BlastBelt:
			if PhantomBoost:
				DashPower = PhantomBlastDashBall.instance()
			else:
				DashPower = BlastDashBall.instance()
				$Anim.play("DoubleDash")
			if(!facingLeft):
				DashPower.position = Vector2(-3,-12)
				DashPower.scale.x = -1
			else:
				DashPower.position = Vector2(3,-12)
			
		else:
				
			if PhantomBoost:
				DashPower = PhantomDashBall.instance()
			else:
				DashPower = DoubleDashBall.instance()
				$Anim.play("DoubleDash")
			if(!facingLeft):
				DashPower.position = Vector2(-3,-12)
				DashPower.scale.x = -1
			else:
				DashPower.position = Vector2(3,-12)
			
	else:
		DashPower = DahsBall.instance()
		
		if PhantomBoost:
			DashPower.modulate = PhantomBoostColour
		if(!facingLeft):
			DashPower.position = Vector2(-10,-12)
			DashPower.scale.x = -1
		else:
			DashPower.position = Vector2(10,-12)
		
	add_child(DashPower)

var Charge = 0

var ChargeBoosted = false

export var chageColor = Color.white
	
func ChargeDashing(delta : float, Xinput : float):
	
	
	
	Charge += 2*delta
	
	SnapToGround = true
	
	if facingLeft:
		Speed = 250
		if Xinput < 0:
			CharacterStates = 1
			Charge = 0
			$AnimatedSprite.modulate = Color.white
		
	else:
		Speed = -250
		if Xinput > 0:
			CharacterStates = 1
			Charge = 0
			$AnimatedSprite.modulate = Color.white
	$AnimatedSprite.play("ChargeDash")
	
	if Charge > 5:
		
		ChargeBoosted = true
		
		$AnimatedSprite.modulate = chageColor
		
		if Input.is_action_just_pressed("Dash") && ChargeBoosted:
			CharacterStates = 11
			Charge = 0
		
	if(!Input.is_action_pressed("Dash") && Charge < 5):
		CharacterStates = 1
		Charge = 0
	if is_on_wall() || !is_on_floor():
		CharacterStates = 1
		Charge = 0
	if Input.is_action_just_pressed("jump"):
		CharacterStates = 1
		SnapToGround = false
		YSpeed = -JumpPower
		JumpCheckTime = 0
		MaxAirMovement = abs(Speed) if abs(Speed) > MaxAirMovementFromStandStill else MaxAirMovementFromStandStill
		Charge = 0
		
func MegaBlast(delta : float):
	
	DashTime -= 4*delta
	
	if 	DashTime < CreatGhostFrame:
		GhostFrames()
		CreatGhostFrame -= 0.3
	
	SnapToGround = false
	
	YSpeed = 0
	
	$ToolAnim.play("MegaDash")
	
	$AnimatedSprite.play("MegaChargeBlast")
	
	MaxAirMovement = 500
	
	if facingLeft:
		
		Speed = 500
	else:
		Speed = -500
	
	if is_on_wall():
		ChargeBoosted = false
		$AnimatedSprite.modulate = Color.white
		$ToolAnim.play("Still")
		CharacterStates = 4
		MaxAirMovement = 100
		HitWall = true
		
		Dashing = false
		$AnimatedSprite/HitColliders/DashCollshion/CollisionShape2D.set_disabled(true)
		if(DashPower != null):	
			DashPower.queue_free()
			DashPower = null
		$AnimatedSprite.play("WallHit")
		if(facingLeft):
			Speed = -150
			YSpeed = -100
		else:
			Speed = 150
			YSpeed = -100
	
#Super Spin ------------------------------->

var SpinnYspeed = 250

func SuperSpin(delta : float,Xinput : float ):
	
	$AnimatedSprite.play("SuperSpin")
	
	Speed += 1000 * (Xinput)* delta
	
	Speed *= pow(1.0 - MoveDamping, delta*10)
	
	
	
	if Xinput > 0 && !facingLeft:
			$AnimatedSprite.scale.x = 1
			
			CrouchTurn = true
			TurnCompleat = false
			facingLeft = true

	if Xinput < 0 && facingLeft:
		$AnimatedSprite.scale.x = -1
		
		
		CrouchTurn = true
		TurnCompleat = false
		facingLeft = false

	
	
	var isLeftWall = checkisvalidwall(left_wall_Raycast)
	var isRightWall = checkisvalidwall(right_wall_Raycast)
	
	
	
	
	if(isLeftWall && Xinput < -0.9 || isRightWall && Xinput > 0.9):
		
		wallJumpValocity = 0
		
		$AnimatedSprite.speed_scale = 1.5
		
		print(is_on_ceiling())
		
		YSpeed = lerp(YSpeed,SpinnYspeed,3*delta)
		
		if is_on_ceiling():
			YSpeed = 250
		else:
			SpinnYspeed = -300
			
		if Input.is_action_just_pressed("jump"):
			
			
			
			
			MaxAirMovement =  250
				
			if(OnLeftWall):
				Speed = -100
				YSpeed = -JumpPower*0.9
				wallJumpValocity = 250
				
			else:
				Speed = 100
				YSpeed = -JumpPower*0.9
				wallJumpValocity = -250
				
		
			
		else:
			MaxAirMovement =  250
		 
	else:
		
		$AnimatedSprite.speed_scale = 1
		
		if(!is_on_floor()):
			YSpeed += 600.0 * delta
			YSpeed = clamp(YSpeed,-10000,400)
			JumpCheckTime -= 1 * delta
			if Input.is_action_just_pressed("jump"):
				JumpCheckTime = 0.2
		else:
			CharacterStates = 1
		
		if is_on_ceiling() && YSpeed < 0:
			YSpeed = 0
			
#wall Sliding ------------------------------->

onready var left_wall_Raycast = $Raycasts/WallJumpCheck/LeftCheck
onready var right_wall_Raycast = $Raycasts/WallJumpCheck/RightCheck

var OnLeftWall = false

var wallJumpValocity = 0


func Update_Wall_Direction():
	var isLeftWall = checkisvalidwall(left_wall_Raycast)
	var isRightWall = checkisvalidwall(right_wall_Raycast)
	if(isLeftWall || isRightWall) && !is_on_floor() :
		
		
		
		if(isLeftWall && facingLeft):
			$AnimatedSprite.scale.x = -1
			facingLeft = false
			wallJumpValocity = 0
		if(isRightWall && !facingLeft):
			$AnimatedSprite.scale.x = 1
			facingLeft = true
			wallJumpValocity = 0
		if $AnimatedSprite.get_animation() == "SpinnJump" && !is_on_ceiling() && CharacterStates != 8 && GotSuperSpin:
			CharacterStates = 8
			YSpeed = -250
		if CharacterStates != 8 && !Digging:
			CharacterStates = 3
			
		
		
		OnLeftWall = true if isLeftWall else false
		
	if(CharacterStates == 3 && ((!isLeftWall && !isRightWall)|| is_on_floor())):
		CharacterStates = 1
		
func checkisvalidwall(wall_Raycasts):
	if wall_Raycasts.is_colliding():
		var dot = acos(Vector2.UP.dot(wall_Raycasts.get_collision_normal()))
		if(dot> 1.5 && dot < 1.7):
			
			return true
	return false
	
	
var WallJumpTimer = 0.3

func HandleWallSliding(delta : float, inputsX : float):
	
	
				
	VerticalMovement(delta,90)
	Speed = 0
	
	
	
	if(OnLeftWall):
		if inputsX > 0.1:
			WallJumpTimer -= 2 * delta
	else:
		if inputsX < -0.1:
			WallJumpTimer -= 2 * delta
	
	if(WallJumpTimer <= 0):
		if OnLeftWall:
			Speed = 10
		else:
			Speed = -10 
	
	
			
	MaxAirMovement = 70
	
	#Do WallJump
	if Input.is_action_just_pressed("jump") && CharacterStates != 8:
		if MaxAirMovement < 120:
				MaxAirMovement = 120
				
		if(OnLeftWall):
			Speed = 400
			YSpeed = -JumpPower*0.9
			wallJumpValocity = 250
		else:
			Speed = -400
			YSpeed = -JumpPower*0.9
			wallJumpValocity = -250
			
			
#HandleAnimations ----------------------------->

var Spinnging

func HanldeAnimations():
	if(!is_on_floor() && !Digging):
		if(abs(Speed) < 125 && !Spinnging):
			if(YSpeed > -1 && gravity > 0):
				$AnimatedSprite.play("Falling")
				
			else:
				$AnimatedSprite.play("Jump")
				
		else:
			$AnimatedSprite.play("SpinnJump")
			Spinnging = true
	if(is_on_floor() && !Digging):
		
			
		if(!TurnCompleat && $AnimatedSprite.get_frame() == 2):
			
			TurnCompleat = true
			
		if(TurnCompleat || $AnimatedSprite.get_animation() == "Falling"):
			Spinnging = false
			
			if(abs(Speed) < 0.1 || is_on_wall()):
				$AnimatedSprite.play("Idle")
			else:
				$AnimatedSprite.play("Run")
			
	


#Switch Tools ------------------------------------------>

var itemCap = 1

var hasShovel = true

var hasFishingRod = false

var hasBlowTorch = false

var Tools = 1

func Tool(inputsX: float, delta : float):
	
	if(Input.is_action_just_pressed("PickTool") && itemCap > 1):
		if Tools < itemCap :
			Tools += 1 
		else:
			Tools = 1
		
	
	match Tools:
		0:
			pass
		1:		
			if !hasShovel:
				Tools = 2
				return
			ShootDirt(delta)
			
		2:
			if !hasFishingRod:
				Tools = 3
				return
			FishingRod(inputsX)
			
		3: 
			if !hasBlowTorch:
				Tools = 1
				return
			BlowTorch(inputsX)
	
			
func CrouchTool():
	if(Input.is_action_just_pressed("PickTool") && itemCap > 1):
		if Tools < itemCap :
			Tools += 1 
		else:
			Tools = 1	
			
	match Tools:
		0:
			pass
		1:
			if !hasShovel:
				Tools = 2
				return
			CrouchShootDirt()	

#Fishing Rod Swinging ------------------------------------------>	

const FishingHook = preload("res://Characters/MainCharacter/MainCharacterProjectiles/Hook.tscn")

const FishingLine = preload("res://Characters/MainCharacter/MainCharacterProjectiles/FishingRope.tscn")

	
var FishRopeLine

func FishingRod(inputsX: float):
	if Input.is_action_just_pressed("UseTool") && !ShotHook:
		ShotHook = true
		#Creat the Hook
		var Hook = FishingHook.instance()
		get_parent().add_child(Hook)
		Hook.Player = self
		
		if inputsX > 0 && !facingLeft:
			$AnimatedSprite.scale.x = 1
			facingLeft = true
		if inputsX < 0 && facingLeft:
			$AnimatedSprite.scale.x = -1
			facingLeft = false
		
		Hook.FacingLeft = facingLeft
		Hook.position = position + Vector2(0,-20)
		
		
		#Creat The Line to the Hook
		var line = FishingLine.instance()
		get_parent().add_child(line)
		line.add_point(position,1)
		line.add_point(position,0)
		FishRopeLine = line
		Hook.HookLine = line
	

var SwingSpeed = 3


var ShotHook = false

var distance = 0

var pivot = Vector2(0,0)


func SetSwingpoint(pivotPoint : Vector2):
	pivot = pivotPoint
	SwingSpeed = -3 if self.global_position.x > pivot.x else 3
	MaxAirMovement = 150
	
		
func Swinging(delta: float, inputsX: float):
	
	#DrawLine From Player To Swing
	FishRopeLine.set_point_position ( 0, Vector2(pivot))
	FishRopeLine.set_point_position ( 1, Vector2(position+Vector2(0,-20)))
	
	
	
	# finding the normal from the character and the pivot point
	var dx =  pivot.x - self.global_position.x
	var dy = pivot.y - self.global_position.y
	
	#Speed Up and slow down
	
	var SpeedMultiplyer = clamp(10-dy,0,50) if distance > 45 else 50
	
	
	
	YSpeed = dx*SwingSpeed*SpeedMultiplyer*0.03
	
	Speed = -dy*SwingSpeed*SpeedMultiplyer*0.03
	
	#DistanceFromPlayerTorope
	distance = self.global_position.distance_to(pivot)
	
	
	#SwingBack
	if(dy > -1):
		SwingSpeed = 3 if dx > 0 else -3
	
	#ComeCloserToHook
	if(distance > 50):
		YSpeed+= 50*dy*delta
		Speed += 50*dx*delta
	#GetFutherAway	
	if(distance < 45):
		SpeedMultiplyer = 50
		YSpeed-= 100*dy*delta
		Speed -= 100*dx*delta
	#FallToground
	if is_on_floor() || is_on_wall() || is_on_ceiling():
		CharacterStates = 1
		FishRopeLine.queue_free()
		
	#Jump Out of Swing
	if (Input.is_action_just_pressed("jump")):
		CharacterStates = 1
		SnapToGround = false
		YSpeed = -JumpPower
		FishRopeLine.queue_free()
		
		if inputsX > 0 && !facingLeft:
			$AnimatedSprite.scale.x = 1
			facingLeft = true
		if inputsX < 0 && facingLeft:
			$AnimatedSprite.scale.x = -1
			facingLeft = false
	
	
#Dirt  Attack ------------------------------------------>	

const DirtProjectile = preload("res://Characters/MainCharacter/MainCharacterProjectiles/DirtShots/SmallDirt.tscn")

var Digging = false

var ToolInuse = false

var currentAttack = 1

var UseTimer = 0.2

var SwingDirrection = 1

func ShootDirt(delta : float):
	
	if inputsX != 0:
		SwingDirrection = inputsX
	
	if Input.is_action_just_pressed("UseTool"):
		
		
		
		
		if is_on_floor():
			if  Input.is_action_pressed("Move_Up") && !Digging:
				
				$Raycasts/DiggCheck.enabled = true
				var ground = $Raycasts/DiggCheck.get_collider()
				
				if(ground != null):
					
					
					if(ground.is_in_group("Diggable")):		
						if abs(Speed) == 0:
							
							$ToolAnim.play("Digging")
							$AnimatedSprite.play("Digging")
						else:
							$ToolAnim.play("Digging")
							$AnimatedSprite.play("DiggRun")
							
						Digging = true
						
						$SoundEffects/Digging.play(0)
						
						var Dirt = DirtProjectile.instance()
						get_parent().add_child(Dirt)
						if facingLeft:
							Dirt.position = position+Vector2(5,-20)
						else:
							Dirt.position = position+Vector2(-5,-20)
					else:
						Digging = true
						$ToolAnim.play("Digging")
						$AnimatedSprite.play("HitRock")
						inputsX = 0
						Speed = 0
						ToolInuse = true
				else:
					Digging = true
					$ToolAnim.play("Digging")
					$AnimatedSprite.play("HitRock")
					inputsX = 0
					Speed = 0
					ToolInuse = true
			else:
				if !Digging:
					
					ToolInuse = true
					
					Speed = inputsX*0.3
					
					inputsX = 0
					
					$AnimatedSprite/HitColliders/ShovelSwing.ShootingLeft = facingLeft
					
					$ToolAnim.play("ShovelSwing")
					$AnimatedSprite.play("ShovelAttack1")
					Digging = true
					currentAttack = 2
			
				else:
					UseTimer = 0.2
					
		else:
			if !Digging:
				if inputsX != 0:
					if(inputsX < 0 && facingLeft):
						$AnimatedSprite.scale.x = -1
						facingLeft = false
					if(inputsX > 0 && !facingLeft):
						$AnimatedSprite.scale.x = 1
						facingLeft = true
				if inputsX == 0:
					if(SwingDirrection < 0 && facingLeft):
						$AnimatedSprite.scale.x = -1
						facingLeft = false
					if(SwingDirrection > 0 && !facingLeft):
						$AnimatedSprite.scale.x = 1
						facingLeft = true
						
				Digging = true
				
				$AnimatedSprite/HitColliders/ShovelSwing.ShootingLeft = facingLeft
				if $AnimatedSprite.get_animation() == "SpinnJump":
					$AnimatedSprite.play("ShovelSpinn")
				else:
					$AnimatedSprite.play("ShovelSwingAir1")
				$ToolAnim.play("ShovelSwing")
				
					
			
			else:
				UseTimer = 0.2
	if UseTimer > 0:
		UseTimer -= 1*delta
	
func CrouchShootDirt():
	
	if Input.is_action_just_pressed("UseTool"):
		if !Digging:
			Digging = true 		
			ToolInuse = true
			if is_on_floor():			
				Speed = 0
				inputsX = 0	
			
			$ToolAnim.play("ShovelSwing")
			$AnimatedSprite.play("CrouchShovel")
		
					
func DigCompleat():
	if UseTimer > 0:
		if is_on_floor():
			if  Input.is_action_pressed("Move_Up"):
				
				ToolInuse = false
				$Raycasts/DiggCheck.enabled = true
				var ground = $Raycasts/DiggCheck.get_collider()
				
				if(ground != null):
					if(ground.is_in_group("Diggable")):	
								
						if abs(Speed) == 0:
							$ToolAnim.play("Digging")
							$AnimatedSprite.play("Digging")
						else:
							$ToolAnim.play("Digging")
							$AnimatedSprite.play("DiggRun")
							
						Digging = true
						
						$SoundEffects/Digging.play(0)
						
						var Dirt = DirtProjectile.instance()
						get_parent().add_child(Dirt)
						Dirt.position = position+Vector2(0,-20)
					
					else:
						Digging = true
						$ToolAnim.play("Digging")
						$AnimatedSprite.play("HitRock")
						inputsX = 0
						Speed = 0
						ToolInuse = true
				else:
					Digging = true
					$ToolAnim.play("Digging")
					$AnimatedSprite.play("HitRock")
					inputsX = 0
					Speed = 0
					ToolInuse = true
			else:
				
				ToolInuse = true
				
				Speed = 0
				inputsX = 0
				$AnimatedSprite/HitColliders/ShovelSwing.ShootingLeft = facingLeft
				
				if currentAttack == 1 :
					$ToolAnim.play("ShovelSwing")
					$AnimatedSprite.play("ShovelAttack1")
					Digging = true
					currentAttack = 2
				else:
					$ToolAnim.play("ShovelSwing")
					$AnimatedSprite.play("ShovelAttack2")
					Digging = true
					currentAttack = 1
		else:
			
					
			Digging = true
			
			$AnimatedSprite/HitColliders/ShovelSwing.ShootingLeft = facingLeft
			
			if currentAttack == 1 :
				$ToolAnim.play("ShovelSwing")
				$AnimatedSprite.play("ShovelSwingAir1")
				currentAttack = 2
			else:
				$ToolAnim.play("ShovelSwing")
				$AnimatedSprite.play("ShovelSwingAir2")
				currentAttack = 1
				
		UseTimer = 0
	else:
		Digging = false	
		ToolInuse = false	

#FixForwhenSwitchingAnimations	
func NotPlayingDigAnim():
	Digging = false	
	ToolInuse = false	
	
#BlowTorch -------------------------------------------------->
var BlowStart = true

var BlowTime = 1

func BlowTorch(inputsX: float):
	if is_on_floor():
		BlowStart = true
	
	else:
		if Input.is_action_just_pressed("UseTool") && BlowStart:
			CharacterStates = 6
			YSpeed = -10			
				
func BlowTorchDown(delta : float):
	
	if(BlowStart):
	
		$AnimatedSprite.play("BlowTourchDownStart")
		
		if $AnimatedSprite.get_frame() == 2:
			BlowStart = false
			BlowTime = 1
	else:	
		BlowTime -= 1*delta	
		YSpeed = -15
		$AnimatedSprite.play("BlowTourchDown")
		if BlowTime < 0:
			CharacterStates = 1
			
	if Input.is_action_just_pressed("UseTool"):
		CharacterStates = 1


#Climbing ------------------------------------------------------------------->

var turning = false

var ClimbingOnToladderFroAbove = false

var ExitingLadder = false

var LadderHasTop = false

var SetCustomOffsetHeight = 0

func Climbing():
	
	match ClimbType:
		1:
			#Climbing vine
			
			if round(ladderPoss.x-5*$AnimatedSprite.scale.x ) < round(position.x):
				Speed = -50
				turning = true
			elif round(ladderPoss.x-5*$AnimatedSprite.scale.x ) > round(position.x):
				Speed = 50
				turning = true
			else:
				Speed = 0
				turning = false
			
			MaxAirMovement = 100
			
			SnapToGround = false
	
			if inputsX < 0 && !facingLeft:
				$AnimatedSprite.scale.x = 1
				$AnimatedSprite.play("Turning")
				facingLeft = true
						
			if inputsX > 0 && facingLeft:
				$AnimatedSprite.scale.x = -1
				$AnimatedSprite.play("Turning")
				facingLeft = false
			
			if Input.is_action_just_pressed("jump"):	
				CharacterStates = 1
				YSpeed = -250
				return
						
			var inputsY =  Input.get_action_strength("Crouch") - Input.get_action_strength("Move_Up");
			
			if position.y > ladderPoss.y + LadderExtence && inputsY > 0:
				inputsY = 0
				
			if turning:
				$AnimatedSprite.play("TurnAroundVine")
				
			else:
				if inputsY == 0:
					 $AnimatedSprite.play("ClimbingVineIdle")
				if inputsY < 0:
					$AnimatedSprite.play("ClimbingUpVine")
				if inputsY > 0:	
					$AnimatedSprite.play("ClimbDownVine")
				if is_on_floor() && inputsY > 0:
					CharacterStates = 1
				
			YSpeed = inputsY*150
		2:
			#Climbing Ladder
			
			if LadderHasTop:
				if ClimbingOnToladderFroAbove:
					YSpeed = 150
					set_collision_mask_bit(9, false)
					FallingThroughGround = true
				
			if round(ladderPoss.y-LadderExtence +32 ) < round(position.y):
				ClimbingOnToladderFroAbove = false
				
				
			if round(ladderPoss.x ) < round(position.x):
				Speed = -50
				turning = true
			elif round(ladderPoss.x ) > round(position.x):
				Speed = 50
				turning = true
			else:
				Speed = 0
				turning = false
			
			if Input.is_action_just_pressed("jump"):	
				CharacterStates = 1
				YSpeed = -250
				set_collision_mask_bit(9, true)
				FallingThroughGround = false
				ExitingLadder = false
				return
			
			SnapToGround = false
			
			MaxAirMovement = 100
			
			set_collision_mask_bit(9, false)
			FallingThroughGround = true
			if LadderHasTop:
				if ExitingLadder:
					$AnimatedSprite.play("ClimbingOffLadder")
					if round(ladderPoss.y-LadderExtence+5) > round(position.y):
						YSpeed = 10
						set_collision_mask_bit(9, true)
						FallingThroughGround = false
						if is_on_floor():
							CharacterStates = 1
							ExitingLadder = false
							return
					else:
						YSpeed = -100
			if !ClimbingOnToladderFroAbove && !ExitingLadder:
				
				var inputsY =  Input.get_action_strength("Crouch") - Input.get_action_strength("Move_Up");
					
				if position.y > ladderPoss.y + LadderExtence && inputsY > 0:
					inputsY = 0
					Speed = 0
					YSpeed = 0
					CharacterStates = 1
				
				if position.y < ladderPoss.y-LadderExtence +32 - SetCustomOffsetHeight && inputsY < 0:
					
					
					inputsY = 0
					
					if LadderHasTop:
						ExitingLadder = true
				
				if inputsY == 0:
					$AnimatedSprite.play("ClimbingLadder")
				if inputsY < 0:
					$AnimatedSprite.play("ClimbingUpLadder")
				if inputsY > 0:	
					$AnimatedSprite.play("ClimbingDownLadder")
				if is_on_floor() && inputsY > 0:
					CharacterStates = 1
					
				YSpeed = inputsY*150


#EnterDoorbuilding------------------------------------------------------------------->
var newDoorPos

func Enteringdoor(Newposition: Vector2):
	$AnimatedSprite.play("EnterDoor")
	Speed = 0
	wallJumpValocity = 0
	if $AnimatedSprite.get_frame() == 4:
		position = Newposition
		CharacterStates = 1
		


#Health -------------------------------------------------->
signal PlayerHit()

signal PlayerDead()

export var BeenHit = false

func HealthUpdated(Damage : int):
	if !Enteringdoor:
		if $Anim.current_animation != "Hit":
			emit_signal("PlayerHit",Damage)
			$Anim.play("Hit")
			BeenHit = true

func _on_Control_Dead():
	CharacterStates = 7
	emit_signal("PlayerDead")
	$AnimatedSprite.play("Dead")
	wallJumpValocity = 0
	
func Money(Amount: int):
	UI.UpdateMoney(Amount)	
#Save Game -------------------------------------------------->

func SaveGame():
	UI.SaveData.camera.PositionX = CameraAria.x
	UI.SaveData.camera.PositionY = CameraAria.y
	UI.SaveData.camera.UpPos = UpPos
	UI.SaveData.camera.Left = leftPos
	
	UI.SaveGame()
	

#RespawnPlayer -------------------------------------------------->
func _on_Control_movePlayerBacktoSpawn(Movement):
	position = Movement
	$AnimatedSprite.play("Idle")
	
	$Camera2D.set_limit(0,saveData.camera.PositionX - saveData.camera.Left) 
	#Set Cameras Right Limit
	$Camera2D.set_limit(2,saveData.camera.PositionX + saveData.camera.Left) 
	#Set Cameras Up Limit
	$Camera2D.set_limit(1,saveData.camera.PositionY - saveData.camera.UpPos) 
	#Set Cameras Down Limit
	$Camera2D.set_limit(3,saveData.camera.PositionY + saveData.camera.UpPos) 
	
	

#PlayerUnPaused -------------------------------------------------->
func _on_Control_CanPlay():
	CharacterStates = 1
	

signal ExitedDoor()


var ExitDirect = 0

var aria = 1
var section = 1

var offset1 = 0
var offset2 = 0
var offset3 = 0
var offset4 = 0
var offset5 = 0

#Enter New Aria
func ExitDoor():
	emit_signal("ExitedDoor",$Camera2D)
	$Anim.play("ExitDoor")
	
	$Camera2D.SetBackground(aria,section,offset1,offset2,offset3,offset4,offset5)
	
	$AnimatedSprite/HitColliders/DashCollshion/CollisionShape2D.set_disabled(true)
	
	match AbilityUse:
		# Standerd Movement
		0:
			CharacterStates = 1
			
		1:
			CharacterStates = 8
		2:
			CharacterStates = 11
		3:
			CharacterStates = 12
			if ExitDirect == 4:
				position.y += 32
			if ExitDirect == 1:
				position.y -= 32
	AbilityUse = 0
	
		
	if(DashPower != null):	
			DashPower.queue_free()
			DashPower = null
	
	$AnimatedSprite.modulate = Color(1,1,1,1)	
		
	if(ExitDirect == 1):
		YSpeed = -300
		
#Enter New Aria Compleate
func ExitCompleate():
		Enteringdoor = false
		

var AbilityUse = 0

var CameraAria

var leftPos

var UpPos

var Enteringdoor = false
	
func _on_CamAria_EnterDoor(Direction : int,AriaPos : Vector2,leftmost : int,upmost : int):
	
	Enteringdoor = true
	
	CameraAria = AriaPos
	leftPos = leftmost
	UpPos = upmost
	
	if CharacterStates == 8:
		AbilityUse = 1
		
		
	if CharacterStates == 11:
		AbilityUse = 2
		
	if CharacterStates == 12:
		AbilityUse = 3
	$Anim.play("EnterDoor")
	
	ExitDirect = Direction
	
	CharacterStates = 7
	
	
#Unlocked New Item ---------------------------------------->
signal GotItem()
func GotItem(ItemID : int,SpawnEnime : bool, EnimeNode : Object):
	emit_signal("GotItem",ItemID,SpawnEnime,EnimeNode)			
	
	
#ZipWireing -------------------------------------------------->			
func ZipWireing(ZipSpeed: float, posintion: float, directionTraveling: bool):
	
	
	$AnimatedSprite.play("Zipwireing")
	
	Speed = 0
	
	YSpeed = 0
	
	wallJumpValocity = 0
	
	if directionTraveling && !facingLeft:
		$AnimatedSprite.scale.x = 1
		facingLeft = true
		
	
	if !directionTraveling && facingLeft:
		$AnimatedSprite.scale.x = -1
		facingLeft = false
	
	if(DashPower != null):
		DashPower.queue_free()
		DashPower = null
				
	if (Input.is_action_just_pressed("jump")):
	
		YSpeed = -JumpPower
		
		MaxAirMovement = abs(ZipSpeed * 130) 
		CharacterStates = 1
		
		if facingLeft:
			Speed = 150 * (ZipSpeed )
			wallJumpValocity = 350 * (ZipSpeed+0.3)
		else:
			Speed = -150 * (ZipSpeed )
			wallJumpValocity = -350 * (ZipSpeed+0.3)
			
		velocity.x = max(velocity.x,-MaxAirMovement)
		velocity.x = min(velocity.x,MaxAirMovement)
	
	if is_on_floor() || is_on_wall():
		CharacterStates = 1
	
		
	if (posintion == 1):
	
		YSpeed = -JumpPower*0.5
		
		MaxAirMovement = abs(ZipSpeed * 130) 
		
		if facingLeft:
			Speed = 130 * (ZipSpeed )
			wallJumpValocity = 350 * (ZipSpeed+0.3)
		else:
			Speed = -130 * (ZipSpeed)
			wallJumpValocity = -350 * (ZipSpeed+0.3)	
		
		velocity.x = max(velocity.x,-MaxAirMovement)
		velocity.x = min(velocity.x,MaxAirMovement)
		
		CharacterStates = 1
	
		
