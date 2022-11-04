using Godot;
using System;
using System.Collections.Generic;
public class PlayerMovementCS : KinematicBody2D
{

	private  object saveData;
	// Declare member variables here. Examples:
	// private int a = 2;
	// private string b = "text";

	// Called when the node enters the scene tree for the first time.

	//Player Details
	private int CharacterStates = 7;
    


	//Ground Snanpping
	private bool SnapToGround = true;
	private Vector2 FLOOR_Normal = Vector2.Up;

	private Vector2 SnapVector = new Vector2(0,8);
	private float FLOOR_MAX_ANGLE =  Mathf.Deg2Rad(50);
	//Turn Off for moving platforms
	private bool SlopeSlide = true;

	//Movement Variables
	private float inputsX = 0.0f;
	private Vector2 velocity = Vector2.Zero;
	private float Speed = 0.0f;
	private float YSpeed = 0.0f;
	private float MaxAirMovement = 20f;
	private float MaxAirMovementFromStandStill = 70f;
	//Sliddy ness   Useful for slighdy platforms
	private  float MoveDamping = 0.5f;
	private float AirMoveDamping = 0.3f;
	private float JumpPower = 250.0f;
	private float gravity = 600;

	private float Stabilgravity = 600;
	private float JumpCheckTime = 0;
	private bool TurnCompleat = true;

	//Secondary Movement Variables
	private float wallJumpValocity = 0;
	private bool facingLeft = true;
	private float SpinnYspeed = 250;
	private bool OnLeftWall = false;
	private float WallJumpTimer = 0.2f;
	private bool Spinnging = false;
	private int ClimbType = 1;
	private float LadderExtence = 1;
	private Vector2 ladderPoss;


	//Crouch Variables
	private bool fallingThroughGround = false;
	private bool CannotUnCrouch = false;
	private bool CrouchTurn = false;

	//Abilitys
	// DashAbilitys
	private bool Dash = true;
	private bool  PowerDash = false;
	private bool  DoubleDash = false;
	private bool  AquaSkim = false;
	private bool  BlastBelt = false;
	private bool  ChargeBoost = false;
	private bool  PhantomBoost = false;
	private bool  GotSuperSpin = false;


	//Get Children
	private AnimationPlayer Anim;
	private AnimatedSprite animatedSprite;
	private Camera2D Cam;
	private CollisionShape2D CrouchCollider;
	private CollisionShape2D Collider;
	private Node2D Music;
	private Node2D SoundEffects;
	private Control GraphicsUI;
	private CollisionShape2D dashCollider;
	private RayCast2D CrouchCheckLeft;
	private RayCast2D CrouchCheckRight;
	private AnimationPlayer ToolAnim;
	private RayCast2D left_wall_Raycast; 
	private RayCast2D right_wall_Raycast;
	private RayCast2D ShoverGroundCheck; 
	private CollisionShape2D ShovelSwing;
	private Area2D ShovelSwingContainer;
	private RayCast2D left_down; 
	private RayCast2D centure_down;
	private RayCast2D right_down; 
	List<RayCast2D> listofgroundRays = new List<RayCast2D>();

	//Sound Effects
	private AudioStreamPlayer2D DigSoundEffect;
	private AudioStreamPlayer2D DashSoundEffect;
	private AudioStreamPlayer2D LandSoundEffect;

	//Partical Effects
	private CPUParticles2D DashParticals;
	private CPUParticles2D SpinParticalEffect;

	//Dashing ----------------------------------------->
	private bool Dashing = false;
	private float DashTime = 2f;
	private float CreatGhostFrame = 1.8f;
	private bool HitWall = false;
	private Node2D DashPower;

	private float PastXpos = 0;
	private PackedScene DahsBall = (PackedScene)ResourceLoader.Load("res://Characters/MainCharacter/MainCharacterProjectiles/DashBoosts/DashBall1.tscn");
	private PackedScene DoubleDashBall = (PackedScene)ResourceLoader.Load("res://Characters/MainCharacter/MainCharacterProjectiles/DashBoosts/DashBall2.tscn");
	private PackedScene PhantomDashBall = (PackedScene)ResourceLoader.Load("res://Characters/MainCharacter/MainCharacterProjectiles/DashBoosts/PhantomDashBall2.tscn");
	private PackedScene BlastDashBall = (PackedScene)ResourceLoader.Load("res://Characters/MainCharacter/MainCharacterProjectiles/DashBoosts/DashBall3.tscn");
	private PackedScene PhantomBlastDashBall = (PackedScene)ResourceLoader.Load("res://Characters/MainCharacter/MainCharacterProjectiles/DashBoosts/PhantomDashBall3.tscn");
	private PackedScene PhantomDashProjectile =(PackedScene) ResourceLoader.Load("res://Characters/MainCharacter/MainCharacterProjectiles/DashBoosts/BlastProjectile/PhantomDashProjectile.tscn");
	private PackedScene  SpeedSprite = (PackedScene)ResourceLoader.Load("res://Characters/MainCharacter/MainCharacterProjectiles/PlayerSprite/PlayerSprite.tscn");

	private PackedScene FishingHook = (PackedScene)ResourceLoader.Load("res://Characters/MainCharacter/MainCharacterProjectiles/Hook.tscn");
	private PackedScene FishingLine = (PackedScene)ResourceLoader.Load("res://Characters/MainCharacter/MainCharacterProjectiles/FishingRope.tscn");

	private PackedScene  DirtProjectile = (PackedScene)ResourceLoader.Load("res://Characters/MainCharacter/MainCharacterProjectiles/DirtShots/SmallDirt.tscn");


	//Seconday Dash Ability Variables
	private float Charge = 0;
	private bool ChargeBoosted = false;


	//Using Tools ---------------------------------------------->
	private bool ToolInuse = false;

	//Dirt  Attack ------------------------------------------>	


	private bool Digging = false;
	private int  currentAttack = 1;
	private float  UseTimer = 0.2f;
	 private float SwingDirrection = 1;

	 //Colour Refrences
	 public Color chageColor = Colors.White;

	[Signal]
    public delegate void GetPlayer();
	

	public override void _Ready()
	{
		SetPhysicsProcess(false);
	
		EmitSignal("GetPlayer",this);
		
		
		Cam = (Camera2D)GetChild(5);

		var Stage = GetParent();

		Stage.Set("Player",this);
		Stage.Set("Playercam",Cam);

	  
		Anim = (AnimationPlayer)GetChild(2);
		ToolAnim = (AnimationPlayer)GetChild(1);
		animatedSprite = (AnimatedSprite)GetChild(0);
		dashCollider = (CollisionShape2D)animatedSprite.GetChild(0).GetChild(1).GetChild(0);
		CrouchCollider = (CollisionShape2D)GetChild(3);
		Collider = (CollisionShape2D)GetChild(4);
		
		CrouchCheckLeft = (RayCast2D)GetChild(3).GetChild(0);
		CrouchCheckRight = (RayCast2D)GetChild(3).GetChild(1);
		ShoverGroundCheck = (RayCast2D)GetChild(6).GetChild(1);

		left_down = (RayCast2D)GetChild(6).GetChild(2).GetChild(0);
		centure_down = (RayCast2D)GetChild(6).GetChild(2).GetChild(1);
		right_down = (RayCast2D)GetChild(6).GetChild(2).GetChild(2);
		listofgroundRays.Add(left_down);
		listofgroundRays.Add(centure_down);
		listofgroundRays.Add(right_down);
		
	
		left_wall_Raycast = (RayCast2D)GetChild(6).GetChild(0).GetChild(0);
		right_wall_Raycast = (RayCast2D)GetChild(6).GetChild(0).GetChild(1);
	    SoundEffects = (Node2D)GetChild(8);
		Music = (Node2D)GetChild(7);
		GraphicsUI = (Control)GetTree().Root.GetNode("Stage1").Get("UI");
		GraphicsUI.Set("Cam",Cam);
		ShovelSwingContainer = (Area2D)GetChild(0).GetChild(0).GetChild(0);
		ShovelSwing = (CollisionShape2D)ShovelSwingContainer.GetChild(0);
		DigSoundEffect = (AudioStreamPlayer2D)SoundEffects.GetChild(0);
		DashSoundEffect = (AudioStreamPlayer2D)SoundEffects.GetChild(1);
		LandSoundEffect = (AudioStreamPlayer2D)SoundEffects.GetChild(2);

		DashParticals = (CPUParticles2D)GetChild(9).GetChild(0);
		SpinParticalEffect= (CPUParticles2D)GetChild(9).GetChild(1);
	}


	//Physics Update Function ---------------------------->
	
	public override void _PhysicsProcess(float delta){
		
		
		//Handle Horizontal Movement
		if (!ToolInuse)
			inputsX = Input.GetActionStrength("Move_Right") - Input.GetActionStrength("Move_Left");
	
	
		switch (CharacterStates){
			// Standerd Movement
			case 1:
				
				//Animations
				HanldeAnimations();

				//Movement
				NotPerformingAnyAction(inputsX,delta);

				

				//Tools
				Tool(inputsX, delta);
				
				//walljumping
				Update_Wall_Direction();
				
				//TimeToStopbeingonwall
				WallJumpTimer = 0.3f;
				break;
			// Swinging
			case 2:
				Swinging(delta,inputsX);
				break;
			// Wall Jumping
			case 3:
				HandleWallSliding(delta, inputsX);
				animatedSprite.Play("WallSliding");
				
				Update_Wall_Direction();
				break;
			//Dashing
			case 4:
				PlayerDashing(delta,inputsX);
				DashTool();
				break;
			//Crouching
			case 5:
				//Crouching
				Crouching(delta,600,inputsX);
				CrouchTool();
				break;
			//BlowtourchTool
			case 6:
				BlowTorchDown(delta);
				break;
		   //InCutScene or pause menu 
			case 7:
				//Stop
				YSpeed = 0;
				Speed = 0;
				break;
			//WallSpinning    moving up wall
			case 8:
				SuperSpin(delta, inputsX);
				
				//walljumping From wall spin
				Update_Wall_Direction();
				break;
			 //ChargeDashing
			case 9:
			   
				ChargeDashing(delta,inputsX);
				break;
			//ZipWireing
			case 10:  
				break;
			//MegaBlast	
			case 11:  
				MegaBlast(delta);
				break;
			//Climbing
			case 12:
				
				Climbing();
				break;
			//Entering Door
			case 13:
				Enteringdoor(newDoorPos);
				break;
			//Holding Item
			case 14:
				//Animations
				HoldHanldeAnimations();

				//Movement
				HoldNotPerformingAnyAction(inputsX,delta);
				break;
		}

		//velocity.x = Speed if abs(Speed) > 20 else 0
		
		
		velocity.x = Speed + wallJumpValocity;
		
		
	//	if(Input.IsActionJustPressed("jump")){
		//	CharacterStates = 14;
		//}
		
		// This is silly I should put this somewhere else so it will run less often when it is not needed. dont forget this joe
		if (CharacterStates == 8){
			velocity.x = Math.Max(velocity.x,-MaxAirMovement);
			velocity.x = Math.Min(velocity.x,MaxAirMovement);
		}

			
		velocity.y = YSpeed;
		
	
	   
		if(SnapToGround){
			velocity.y = MoveAndSlideWithSnap(velocity,SnapVector  ,FLOOR_Normal,SlopeSlide,4,FLOOR_MAX_ANGLE).y;
			
		}
		else{
			velocity = MoveAndSlide(velocity,FLOOR_Normal);
		}
	}
	
	//Default Actions ------------------------------------------>

	void NotPerformingAnyAction(float inputsX,float delta){
		Horizontal_Movement(inputsX,delta);
		VerticalMovement(delta,600);
	}
	
	//Set Horizontal Movement
	void Horizontal_Movement(float inputsX ,float delta){
		
		//fallThroughPlatforms
		if (fallingThroughGround){
			if (Input.IsActionJustReleased("Crouch")){
				SetCollisionMaskBit(9, true);
				
				fallingThroughGround = false;
			}
		}
		//set ground movement
		if (IsOnFloor()){
			
		

			//fallThroughPlatforms
			if (Input.IsActionJustPressed("Crouch")){
				SetCollisionMaskBit(9, false);
				fallingThroughGround = true;
			}
			
			 
			
			//handleCrouching
			if (Input.IsActionPressed("Crouch")){
				
				CharacterStates = 5;
				animatedSprite.Play("BeginCrouch");
				animatedSprite.Offset = new Vector2(0,2);
				Collider.Disabled = true;
				CrouchCollider.Disabled = false;
			}
			else if (fallingThroughGround){
				SetCollisionMaskBit(9, true);
				fallingThroughGround = false;
			}
			//handleDash
			if(Input.IsActionJustPressed("Dash") && Dash && !ToolInuse && !Input.IsActionJustPressed("jump")){
				HitWall = false;
				CharacterStates = 4;
				DashTime = 2;
				CreatGhostFrame = 1.8f;
				animatedSprite.Play("Dashing");
				DashSoundEffect.Play(0);
				
				Cam.Call("ShakeCamera",0.2f,0.1f);

				if (facingLeft){
					dashCollider.Position = new Vector2(6,-13);
				}
				else{
					 dashCollider.Position = new Vector2(-6,-13);
				}

				dashCollider.Disabled = false;
						
				Dashing = true;
				
				if (PowerDash){
					creatDashPower();
				}
			}
			//SetDirectionFacing
			if (CharacterStates != 4 && !Digging){
				if (inputsX > 0 && !facingLeft){
					animatedSprite.Scale = new Vector2(1,1);
					animatedSprite.Play("Turning");
					TurnCompleat = false;
					facingLeft = true;
					MaxAirMovement = 70;
				}
				if (inputsX < 0 && facingLeft){
					animatedSprite.Scale = new Vector2(-1,1);
					animatedSprite.Play("Turning");
					TurnCompleat = false;
					facingLeft = false;
					MaxAirMovement = 70;
				}
			}
			//SetMovingSpeed
			Speed += 900 * (inputsX)* delta;
			Speed *= (float)Math.Pow(1.0f - MoveDamping, delta*10);
			
			//WallJumpSpeed
			wallJumpValocity = 0;
			
			if (ChargeBoosted){
				animatedSprite.Modulate = Colors.White;
				ChargeBoosted = false;
			}
		}
		//set Air movement horizontal
		else{
			wallJumpValocity =  Mathf.Lerp(wallJumpValocity, 0, 0.1f);
				
			
			Speed += 900 * (inputsX) *delta;
			Speed *= (float)Math.Pow(1.0f - AirMoveDamping, delta*10);
			Speed = Math.Max(Speed,-Math.Abs(MaxAirMovement));
			Speed = Math.Min(Speed,Math.Abs(MaxAirMovement));
			
			//MegaChargeBoosted
			if (Input.IsActionJustPressed("Dash") && ChargeBoosted){
				CharacterStates = 11;
				Charge = 0;
				
			}
		}

		if (Math.Abs(inputsX) < 0.1 && Math.Abs(Speed) < 30){
			Speed = 0;
		}
		if(IsOnWall()){
			
			SnapToGround = false;
			MaxAirMovement = 90;
		}
	}
	//Vertical Movement
	void VerticalMovement(float delta,float MaxfallSpeed){
		
		//Handle Gravity
		if(!IsOnFloor()){
			YSpeed += gravity * delta;
			YSpeed = Mathf.Clamp(YSpeed,-10000,MaxfallSpeed);
			JumpCheckTime -= 1 * delta;
			if (Input.IsActionJustPressed("jump")){
				JumpCheckTime = 0.2f;
			}
		}
		else{
			SnapToGround = true;
			YSpeed = 5;
		}  
	
		//bumpHeadOnceling	
		if (IsOnCeiling() && YSpeed < 0 ){
			YSpeed = 0;
		}
		//Small jump
		if (Input.IsActionJustPressed("jump") && velocity.y < -50 && !Dashing && gravity > 0){
			YSpeed = -50;
		}
		//Spin jump	
		if (!IsOnFloor() && velocity.y < 60 && Input.IsActionJustPressed("jump") && wallJumpValocity == 0){
			
			if (Math.Abs(Speed) >= 70  && (inputsX > 0 && facingLeft  || inputsX < 0 && !facingLeft)){
				
				if(animatedSprite.Animation == "Falling" ||animatedSprite.Animation == "Jump"){
					if (MaxAirMovement < 250)
						MaxAirMovement = 250;
					
					if (facingLeft) Speed += 100;
					else Speed -= 100;

					animatedSprite.Play("SpinnJump");
				}
			}
		}
		//CheckIfCanJump
		if ((Input.IsActionJustPressed("jump") || JumpCheckTime > 0)&& IsOnFloor() &&  !Input.IsActionJustPressed("Dash")){
			SnapToGround = false;
			YSpeed = -JumpPower;
			JumpCheckTime = 0;
		
			if (Math.Abs(Speed)> MaxAirMovementFromStandStill)  
				MaxAirMovement = Math.Abs(Speed);
			else 
				MaxAirMovement = MaxAirMovementFromStandStill;
		}

	   
	}

	//Crouching ------------------------------------->
	


	void  Crouching(float delta ,float MaxfallSpeed,float inputsX){
	
		if(CrouchTurn){
			if (animatedSprite.Frame == 1)
				CrouchTurn = false;
		}
		//SetMovingSpeed
		Speed += 700 * (inputsX)* delta;
		Speed *= (float)Math.Pow(1.0f - MoveDamping, delta*10);
			
			
		if(!IsOnFloor()){
			
			//CrouchAnimations
			if(YSpeed > 0 && !ToolInuse)
				animatedSprite.Play("CrouchFall");
			
			//Crouch Gravity	
			YSpeed += gravity * delta;
			YSpeed = Mathf.Clamp(YSpeed,-1000,MaxfallSpeed);
			JumpCheckTime -= 1 * delta;
			if (Input.IsActionJustPressed("jump"))
				JumpCheckTime = 0.2f;
		}   
		else{
			SnapToGround = true;
			YSpeed = 5;
			if ((Input.IsActionPressed("Crouch") || CannotUnCrouch) && !CrouchTurn && !ToolInuse){
				
				if(Math.Abs(Speed) < 20 || IsOnWall())
					animatedSprite.Play("Crouching");
				else
					animatedSprite.Play("CrouchRun");
			}

			//SetDirectionFacing
			if (inputsX > 0 && !facingLeft){
				animatedSprite.Scale = new Vector2(1,1);
				animatedSprite.Play("CrouchingTurn");
				CrouchTurn = true;
				TurnCompleat = false;
				facingLeft = true;
				MaxAirMovement = 70;
			}
			if (inputsX < 0 && facingLeft){
				animatedSprite.Scale = new Vector2(-1,1);
				animatedSprite.Play("CrouchingTurn");
				CrouchTurn = true;
				TurnCompleat = false;
				facingLeft = false;
				MaxAirMovement = 70;
			}
		}

		//bumpHeadOnceling	
		if (IsOnCeiling() && YSpeed < 0)
			YSpeed = 0;
		
		//Small jump
		if (Input.IsActionJustPressed("jump") && velocity.y < -50)
			YSpeed = -50;
		
		//CheckIfCanJump
		if ((Input.IsActionJustPressed("jump") || JumpCheckTime > 0)&& IsOnFloor()){
			
			animatedSprite.Play("CrouchJump");
			
			SnapToGround = false;
			YSpeed = -JumpPower*0.8f;
			JumpCheckTime = 0;
			if (Math.Abs(Speed) > MaxAirMovementFromStandStill)
				MaxAirMovement = Math.Abs(Speed);
			else MaxAirMovement = MaxAirMovementFromStandStill;
		}

		if (!Input.IsActionPressed("Crouch") && !ToolInuse){
			CrouchCheckLeft.Enabled = true;
			CrouchCheckRight.Enabled = true;
			if (!CrouchCheckLeft.IsColliding() && !CrouchCheckRight.IsColliding()){
				CannotUnCrouch = false;
				animatedSprite.Play("CrouchGetUp");
				if (animatedSprite.Frame == 2){
					CharacterStates = 1;
					Collider.Disabled = false;
					CrouchCollider.Disabled = true;
					animatedSprite.Offset = new Vector2(0,0);
					CrouchCheckLeft.Enabled = false;
					CrouchCheckRight.Enabled = false;
				}
			}
			else CannotUnCrouch = true;
		}
	}

	void PlayerDashing(float delta,float inputsX){
	
		//Dash Duration
		DashTime -= 4*delta;
		
		//Dash Up Slopes
		SnapToGround = false;
		
		if(!HitWall){
			MaxAirMovement = 150;
		}
		
		//Ramp Momentum
		var rot = GetFloorNormal();
		

		

		if(IsOnFloor() && (facingLeft && rot.x < 0 || !facingLeft && rot.x > 0)){
			
			YSpeed = (1+rot.y)*-800;
		}

		if (!IsOnFloor()){
			YSpeed += gravity * 0.5f * delta;
			YSpeed = Mathf.Clamp(YSpeed,-1000,600);
			JumpCheckTime -= 1 * delta;
			if (Input.IsActionJustPressed("jump"))
				JumpCheckTime = 0.2f;
		}
		
		
			
		if(!HitWall){
			
			//Set GhostFrames
			if (PhantomBoost){
				if 	(DashTime < CreatGhostFrame){
					GhostFrames();
					CreatGhostFrame -= 0.3f;
				}
			}
			if (Input.IsActionJustPressed("jump") && IsOnFloor())
				YSpeed = -JumpPower*0.7f;
				
		
			
			if(DashTime <= 0){
				gravity = Stabilgravity;
				ShovelDashing = false;
				SpinParticalEffect.Emitting = false;
				if (!ChargeBoost){
					CharacterStates = 1;
					Dashing = false;
					dashCollider.Disabled = true;
				}
				else
					CharacterStates = 9;
					
				if(DashPower != null){
					DashPower.QueueFree();
					DashPower = null;
				}
					
				if(BlastBelt && PowerDash){
					if (PhantomBoost){
						var Projectile = (Node2D)PhantomDashProjectile.Instance();
						GetParent().AddChild(Projectile);
						if(!facingLeft){
							Projectile.Position = GlobalPosition+new Vector2(-3,-12);
							Projectile.Scale = new Vector2(-1,1);
						}
						else
							Projectile.Position =  GlobalPosition+new Vector2(3,-12);
					}
				}
			}		
			if(facingLeft)
				Speed = 200 + (inputsX*50);
			else
				Speed = -200 + (inputsX*50);
		}

		if( IsOnWall()){
			HitWall = true;
			gravity = Stabilgravity;
			ShovelDashing = false;
			SpinParticalEffect.Emitting = false;
			Dashing = false;
			dashCollider.Disabled = true;
			Cam.Call("ShakeCamera",0.5f,0.12f);

			if(DashPower != null){
				DashPower.QueueFree();
				DashPower = null;
			}
			animatedSprite.Play("WallHit");
			if(facingLeft){
				Speed = -150;
				YSpeed = -100;
			}
			else{
				Speed = 150;
				YSpeed = -100;
			}
		}
		if (HitWall){
			ShovelDashing = false;
			SpinParticalEffect.Emitting = false;
			gravity = Stabilgravity;
			if (animatedSprite.Frame == 4 || Mathf.Round(Position.x) == PastXpos ){
				MaxAirMovement = 60;
				
				CharacterStates = 1;
				animatedSprite.Play("Run");
			}
			PastXpos = Mathf.Round(Position.x) ;
		}
	}

	void GhostFrames(){
		var Sp = (Sprite)SpeedSprite.Instance();
		GetParent().AddChild(Sp);
		Sp.Position = Position + new Vector2(0,-16);
		if (!facingLeft){
			Sp.Scale = new Vector2(-1,1);
		}
		Sp.Texture = animatedSprite.Frames.GetFrame( animatedSprite.Animation ,  animatedSprite.Frame);
		//Check to make sure this works joe joe ---------------------------------------------------------------------M<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		AnimationPlayer Spriteanim = (AnimationPlayer)Sp.GetChild(0);
		Spriteanim.Play("SpriteDie");
	}

	public Color PhantomBoostColour = Color.Color8(0,0,0);
	void creatDashPower(){
	
		if (DoubleDash){
			if (BlastBelt){
				if (PhantomBoost)
					DashPower = (Node2D)PhantomBlastDashBall.Instance();
				else{
					DashPower = (Node2D)BlastDashBall.Instance();
					Anim.Play("DoubleDash");
				}
				if(!facingLeft){
					DashPower.Position = new Vector2(-3,-12);
					DashPower.Scale = new Vector2(-1,1);
				}
				else
					DashPower.Position = new Vector2(3,-12);
			}	
			else{
					
				if (PhantomBoost)
					DashPower = (Node2D)PhantomDashBall.Instance();
				else{
					DashPower = (Node2D)DoubleDashBall.Instance();
					Anim.Play("DoubleDash");
				}
				if(!facingLeft){
					DashPower.Position = new Vector2(-3,-12);
					DashPower.Scale = new Vector2(-1,1);
				}
				else
					DashPower.Position = new Vector2(3,-12);
			}
		}		
		else{
			DashPower =  (Node2D)DahsBall.Instance();
			
			if (PhantomBoost)
				DashPower.Modulate = PhantomBoostColour;
			if(!facingLeft){
				DashPower.Position = new Vector2(-10,-12);
				DashPower.Scale = new Vector2(-1,1);
			}
			else
				DashPower.Position = new Vector2(10,-12);
		}

		AddChild(DashPower);
	}




	
	void ChargeDashing(float delta,float Xinput){
	
	
	
		Charge += 2*delta;
		
		SnapToGround = true;
		
		if (facingLeft){
			Speed = 250;
			if (Xinput < 0){
				CharacterStates = 1;
				Charge = 0;
				animatedSprite.Modulate = Colors.White;
			}
		}	
		else{
			Speed = -250;
			if (Xinput > 0){
				CharacterStates = 1;
				Charge = 0;
				animatedSprite.Modulate = Colors.White;
			}
		}
		animatedSprite.Play("ChargeDash");
		
		if (Charge > 5){
			
			ChargeBoosted = true;
			
			animatedSprite.Modulate = chageColor;
			
			if (Input.IsActionJustPressed("Dash") && ChargeBoosted){
				CharacterStates = 11;
				Charge = 0;
			}
		}

		if(!Input.IsActionPressed("Dash") && Charge < 5){
			CharacterStates = 1;
			Charge = 0;
		}
		if (IsOnWall() || !IsOnFloor()){
			CharacterStates = 1;
			Charge = 0;
		}
		if (Input.IsActionJustPressed("jump")){
			CharacterStates = 1;
			SnapToGround = false;
			YSpeed = -JumpPower;
			JumpCheckTime = 0;

			if (Math.Abs(Speed) > MaxAirMovementFromStandStill)
				MaxAirMovement = Math.Abs(Speed);
			else 
				MaxAirMovement = MaxAirMovementFromStandStill;
				
			Charge = 0;
		}
	}


	void MegaBlast(float delta){
	
		DashTime -= 4*delta;
		
		if 	(DashTime < CreatGhostFrame){
			GhostFrames();
			CreatGhostFrame -= 0.3f;
		}
		SnapToGround = false;
		
		YSpeed = 0;
		
		ToolAnim.Play("MegaDash");
		
		animatedSprite.Play("MegaChargeBlast");
		
		MaxAirMovement = 500;
		
		if (facingLeft){
			Speed = 500;
		}
		else{
			Speed = -500;
		}
		if (IsOnWall()){
			ChargeBoosted = false;
			animatedSprite.Modulate = Colors.White;
			ToolAnim.Play("Still");
			CharacterStates = 4;
			MaxAirMovement = 100;
			HitWall = true;
			gravity = Stabilgravity;
			ShovelDashing = false;
			SpinParticalEffect.Emitting = false;
			Dashing = false;
			dashCollider.Disabled = true;
			if(DashPower != null){
				DashPower.QueueFree();
				DashPower = null;
			}
			animatedSprite.Play("WallHit");
			if(facingLeft){
				Speed = -150;
				YSpeed = -100;
			}
			else{
				Speed = 150;
				YSpeed = -100;
			}
		}
	}
//Super Spin ------------------------------->



	void SuperSpin(float delta,float Xinput){
		
		animatedSprite.Play("SuperSpin");
		
		Speed += 1000 * (Xinput)* delta;
		
		Speed *= (float)Math.Pow(1.0f - MoveDamping, delta*10);
		
		
		
		if (Xinput > 0 && !facingLeft){
				animatedSprite.Scale = new Vector2(1,1);
				
				CrouchTurn = true;
				TurnCompleat = false;
				facingLeft = true;
		}
		if (Xinput < 0 && facingLeft){
			animatedSprite.Scale = new Vector2(-1,1);
			
			
			CrouchTurn = true;
			TurnCompleat = false;
			facingLeft = false;

		}
		
		var isLeftWall = checkisvalidwall(left_wall_Raycast);
		var isRightWall = checkisvalidwall(right_wall_Raycast);
		
		
		
		
		if(isLeftWall && Xinput < -0.9 || isRightWall && Xinput > 0.9){
			
			wallJumpValocity = 0;
			
			animatedSprite.SpeedScale = 1.5f;
			
		
			
			YSpeed = Mathf.Lerp(YSpeed,SpinnYspeed,3*delta);
			
			if (IsOnCeiling())
				YSpeed = 250;
			else
				SpinnYspeed = -300;
				
			if (Input.IsActionJustPressed("jump")){
				

				MaxAirMovement =  250;
					
				if(OnLeftWall){
					Speed = -100;
					YSpeed = -JumpPower*0.9f;
					wallJumpValocity = 250;
				}	
				else{
					Speed = 100;
					YSpeed = -JumpPower*0.9f;
					wallJumpValocity = -250;
				}	
			
			}	
			else
				MaxAirMovement =  250;
		}	
		else{
			
			animatedSprite.SpeedScale = 1;
			
			if(!IsOnFloor()){
				YSpeed += 600.0f * delta;
				YSpeed = Mathf.Clamp(YSpeed,-10000,400);
				JumpCheckTime -= 1 * delta;
				if (Input.IsActionJustPressed("jump"))
					JumpCheckTime = 0.2f;
			}
			else
				CharacterStates = 1;
			
			if (IsOnCeiling() && YSpeed < 0)
				YSpeed = 0;

		}
	}
	void Update_Wall_Direction(){
		bool isLeftWall = checkisvalidwall(left_wall_Raycast);
		bool isRightWall = checkisvalidwall(right_wall_Raycast);
		if((isLeftWall || isRightWall) && !IsOnFloor()){
			

			if(isLeftWall && facingLeft){
				animatedSprite.Scale = new Vector2(-1,1);
				facingLeft = false;
				wallJumpValocity = 0;
			}
			if(isRightWall && !facingLeft){
				animatedSprite.Scale= new Vector2(1,1);
				facingLeft = true;
				wallJumpValocity = 0;
			}
			if (animatedSprite.Animation == "SpinnJump" && !IsOnCeiling() && CharacterStates != 8 && GotSuperSpin){
				CharacterStates = 8;
				YSpeed = -250;
			}
			if (CharacterStates != 8 && !Digging)
				CharacterStates = 3;
				
			
			if (isLeftWall){
				OnLeftWall = true;
				
			}
			else{
				OnLeftWall = false;
				
			}
		}	
		if(CharacterStates == 3 && ((!isLeftWall && !isRightWall)|| IsOnFloor()))
			CharacterStates = 1;
	}	
	 public bool checkisvalidwall(RayCast2D wall_Raycasts){
		if (wall_Raycasts.IsColliding()){
			float dot = (float)Mathf.Acos(Vector2.Up.Dot(wall_Raycasts.GetCollisionNormal()));
			if(dot > 1.5f && dot < 1.7f){
		
				return true;
			}
		}
		
		return false;
	}


	void HandleWallSliding(float delta,float inputsX){
	
	
				
		VerticalMovement(delta,90);
		Speed = 0;
		
		
		
		if(OnLeftWall){
			if (inputsX > 0.1)
				WallJumpTimer -= 2 * delta;
		}
		else{
			if (inputsX < -0.1)
				WallJumpTimer -= 2 * delta;
		}
		if(WallJumpTimer <= 0){
			if (OnLeftWall)
				Speed = 10;
			else
				Speed = -10 ;
		}
		
				
		MaxAirMovement = 70;
		
		//Do WallJump

		if (Input.IsActionJustPressed("jump") && CharacterStates != 8){
			if (MaxAirMovement < 120)
					MaxAirMovement = 120;
					
			if(OnLeftWall){
				Speed = 400;
				YSpeed = -JumpPower*0.9f;
				wallJumpValocity = 250;
				
			}
			else{
				Speed = -400;
				YSpeed = -JumpPower*0.9f;
				wallJumpValocity = -250;
				
			}
		}
	}


	//HandleAnimations ----------------------------->
	bool aboutToTouchGround = false;
	void HanldeAnimations(){
		

		if(!IsOnFloor()){

			if(animatedSprite.Animation == ("ShovelSpinn")){
				
				aboutToTouchGround = CheckForGround();

				if(aboutToTouchGround){
					YSpeed = -JumpPower*0.5f;
					SnapToGround = false;
					JumpCheckTime = 0;
					if(Speed < 200){
						Speed += 50;
					}
				}

			}

			
			if(!Digging){
			
				if(Math.Abs(Speed) < 125 && !Spinnging){
					if(YSpeed > -1 && gravity > 0){
						animatedSprite.Play("Falling");

						aboutToTouchGround = CheckForGround();
						

						if(aboutToTouchGround && !LandSoundEffect.Playing){
							LandSoundEffect.Play();
							aboutToTouchGround = false;
						}
					}
					else
						animatedSprite.Play("Jump");
				}		
				else{
					animatedSprite.Play("SpinnJump");
					Spinnging = true;
				}
			}
		}
		
		if(IsOnFloor()){
			
			//if(animatedSprite.Animation == ("ShovelSpinn")){
			//	YSpeed = -100;
			//	animatedSprite.Play("SpinnJump");
			//	Spinnging = true;
			//	Digging = false;
			//}

			if(!Digging){
				if(!TurnCompleat && animatedSprite.Frame == 2){
					TurnCompleat = true;
				}
				if(TurnCompleat || animatedSprite.Animation == "Falling"){
					Spinnging = false;
			
					if(Math.Abs(Speed) < 0.1 || IsOnWall()){
						animatedSprite.Play("Idle");
					
					}
					else{
						animatedSprite.Play("Run");
						
						
					}
				}
			}
		}

		if (animatedSprite.Animation == "Run"){
			DashParticals.Emitting = true;
			if (facingLeft){
				DashParticals.Direction = new Vector2(-0.3f,-0.935f);
			}else{
				DashParticals.Direction = new Vector2(0.3f,-0.935f);
			}
		}else{
				DashParticals.Emitting = false;
		}

	}

	bool CheckForGround(){
		foreach(RayCast2D ray in listofgroundRays){
			ray.Enabled = true;
			if(ray.IsColliding()){
				ray.Enabled = false;
				return true;
			}
		}
		return false;
	}


	//Switch Tools ------------------------------------------>

	private int itemCap = 1;

	private bool  hasShovel = true;

	private bool hasFishingRod = false;

	private bool hasBlowTorch = false;

	private int tools = 1;

	void Tool(float inputsX,float delta){
		
		if(Input.IsActionJustPressed("PickTool") && itemCap > 1){
			if (tools < itemCap)
				tools += 1 ;
			else
				tools = 1;
		}
		
		switch (tools){
			case 0:
				break;
			case 1:		
				if (!hasShovel){
					tools = 2;
					return;
				}
				ShootDirt(delta);
				break;
			case 2:
				if (!hasFishingRod){
					tools = 3;
					return;
				}
				FishingRod(inputsX);
				break;
			case 3: 
				if (!hasBlowTorch){
					tools = 1;
					return;
				}
				BlowTorch(inputsX);
				break;
		}
		
	}			
	void CrouchTool(){
		if((Input.IsActionJustPressed("PickTool") && itemCap > 1)){
			if (tools < itemCap)
				tools += 1;
			else
				tools = 1;	
		}	
		switch (tools){
			case 0:
				break;
			case 1:
				if (!hasShovel){
					tools = 2;
					return;
				}
				CrouchShootDirt();
				break;
		}
	}

	void DashTool(){

		if((Input.IsActionJustPressed("PickTool") && itemCap > 1)){
			if (tools < itemCap)
				tools += 1;
			else
				tools = 1;	
		}
		switch (tools){
			case 0:
				break;
			case 1:
				if (!hasShovel){
					tools = 2;
					return;
				}
				ShovelDash();
				break;
		}
	}
	
	//Fishing Rod Swinging ------------------------------------------>	
	
	private Line2D FishRopeLine;


	private float SwingSpeed = 3;


	private bool ShotHook = false;

	private float distance = 0;

	private Vector2 pivot = new Vector2(0,0);

	void FishingRod(float inputsX){
		if (Input.IsActionJustPressed("UseTool") && !ShotHook){
			ShotHook = true;
			//Creat the Hook
			Node2D Hook = (Node2D)FishingHook.Instance();
		
			GetParent().AddChild(Hook);
			Hook.Set("Player",this);
			
			if (inputsX > 0 && !facingLeft){
				animatedSprite.Scale = new Vector2(1,1);
				facingLeft = true;
			}
			if (inputsX < 0 && facingLeft){
				animatedSprite.Scale = new Vector2(-1,1);
				facingLeft = false;
			}
		
			Hook.Set("FacingLeft" ,facingLeft);
			Hook.Position = Position + new Vector2(0,-20);
			
			
			//Creat The Line to the Hook
			Line2D line = (Line2D)FishingLine.Instance();
			GetParent().AddChild(line);
			line.AddPoint(this.Position,1);
			line.AddPoint(this.Position,0);
			FishRopeLine = line;
			Hook.Set("HookLine",line);
		}
	}

	void SetSwingpoint(Vector2 pivotPoint){
		pivot = pivotPoint;
		if (GlobalPosition.x > pivot.x )
			SwingSpeed = -3;
		 else 
		 	SwingSpeed = 3;
		MaxAirMovement = 150;
	}
		
	void Swinging(float delta,float inputsX){
		
		//DrawLine From Player To Swing
		FishRopeLine.SetPointPosition ( 0, new Vector2(pivot));
		FishRopeLine.SetPointPosition ( 1, new Vector2(Position+ new Vector2(0,-20)));
		
		
		
		//finding the normal from the character and the pivot point
		float dx =  pivot.x - GlobalPosition.x;
		float dy = pivot.y - GlobalPosition.y;
		float SpeedMultiplyer;
		//Speed Up and slow down
		if (distance > 45)
			 SpeedMultiplyer = Mathf.Clamp(10-dy,0,50);
		else 
			SpeedMultiplyer = 50;
		
		
		
		YSpeed = dx*SwingSpeed*SpeedMultiplyer*0.03f;
		
		Speed = -dy*SwingSpeed*SpeedMultiplyer*0.03f;
		
		//DistanceFromPlayerTorope
		distance = GlobalPosition.DistanceTo(pivot);
		
		
		//SwingBack
		if(dy > -1){
		
			if (dx > 0 )
				SwingSpeed = 3;
			else 
				SwingSpeed = -3;
		}
		//ComeCloserToHook
		if(distance > 50){
			YSpeed+= 50*dy*delta;
			Speed += 50*dx*delta;
		}
		//GetFutherAway	
		if(distance < 45){
			SpeedMultiplyer = 50;
			YSpeed-= 100*dy*delta;
			Speed -= 100*dx*delta;
		}
		//FallToground
		if (IsOnFloor() || IsOnWall() || IsOnCeiling()){
			CharacterStates = 1;
			FishRopeLine.QueueFree();
		}
		//Jump Out of Swing
		if (Input.IsActionJustPressed("jump")){
			CharacterStates = 1;
			SnapToGround = false;
			YSpeed = -JumpPower;
			FishRopeLine.QueueFree();
			
			if (inputsX > 0 && !facingLeft){
				animatedSprite.Scale = new Vector2(1,1);
				facingLeft = true;
			}
			if (inputsX < 0 && facingLeft){
				animatedSprite.Scale = new Vector2(-1,1);
				facingLeft = false;
			}
		}
	}

	//Dirt  Attack ------------------------------------------>	



	void ShootDirt(float delta){
		
		if (inputsX != 0)
			SwingDirrection = inputsX;
		
		if (Input.IsActionJustPressed("UseTool")){
			
			
			
			
			if (IsOnFloor()){
				if ( Input.IsActionPressed("Move_Up") && !Digging){
					
					ShoverGroundCheck.Enabled = true;

					Node2D ground = (Node2D)ShoverGroundCheck.GetCollider();
					
					if(ground != null){
						
						
						if(ground.IsInGroup("Diggable")){		
							if (Math.Abs(Speed) == 0){
								
								ToolAnim.Play("Digging");
								animatedSprite.Play("Digging");
							}
							else{
								ToolAnim.Play("Digging");
								animatedSprite.Play("DiggRun");
							}
								
							Digging = true;
							
							DigSoundEffect.Play(0);
							
							Node2D Dirt = (Node2D)DirtProjectile.Instance();
							GetParent().AddChild(Dirt);
							if (facingLeft)
								Dirt.Position = Position+ new Vector2(5,-20);
							else
								Dirt.Position = Position+ new Vector2(-5,-20);
						}
						else{
							Digging = true;
							ToolAnim.Play("Digging");
							animatedSprite.Play("HitRock");
							inputsX = 0;
							Speed = 0;
							ToolInuse = true;
						}
					}
					else{
						Digging = true;
						ToolAnim.Play("Digging");
						animatedSprite.Play("HitRock");
						inputsX = 0;
						Speed = 0;
						ToolInuse = true;
					}
				}
				else{
					if (!Digging){
						
						ToolInuse = true;
						
						Speed = inputsX*0.3f;
						
						inputsX = 0;
					

						ShovelSwingContainer.Set("ShootingLeft", facingLeft);
						
						ToolAnim.Play("ShovelSwing");
						animatedSprite.Play("ShovelAttack1");
						Digging = true;
						currentAttack = 2;
					}
					else
						UseTimer = 0.2F;
				}
			}			
			else{
				if (!Digging){
					if (inputsX != 0){
						if(inputsX < 0 && facingLeft){
							animatedSprite.Scale = new Vector2(-1,1);
							facingLeft = false;
						}
						if(inputsX > 0 && !facingLeft){
							animatedSprite.Scale = new Vector2(1,1);
							facingLeft = true;
						}
					}
					if (inputsX == 0){
						if(SwingDirrection < 0 && facingLeft){
							animatedSprite.Scale = new Vector2(-1,1);
							facingLeft = false;
						}
						if(SwingDirrection > 0 && !facingLeft){
							animatedSprite.Scale = new Vector2(1,1);
							facingLeft = true;
						}
					}	
					Digging = true;
					
					ShovelSwing.Set("ShootingLeft", facingLeft);

					if (animatedSprite.Animation== "SpinnJump")
						animatedSprite.Play("ShovelSpinn");
					else
						animatedSprite.Play("ShovelSwingAir1");
					ToolAnim.Play("ShovelSwing");
					
						
				}
				else
					UseTimer = 0.2F;
			}
		}
		if (UseTimer > 0)
			UseTimer -= 1*delta;
		
	}
	void CrouchShootDirt(){
		
		if (Input.IsActionJustPressed("UseTool")){
			if (!Digging){
				Digging = true 	;	
				ToolInuse = true;
				if (IsOnFloor()){
					Speed = 0;
					inputsX = 0	;
				}
				ToolAnim.Play("ShovelSwing");
				animatedSprite.Play("CrouchShovel");
			}
		}
	}
					
	void DigCompleat(){
		if (UseTimer > 0){
			if (IsOnFloor()){
				if  (Input.IsActionPressed("Move_Up")){
					
					ToolInuse = false;
					ShoverGroundCheck.Enabled = true;
					Node2D ground = (Node2D)ShoverGroundCheck.GetCollider();
					
					if(ground != null){
						if(ground.IsInGroup("Diggable")){
									
							if (Math.Abs(Speed) == 0){
								ToolAnim.Play("Digging");
								animatedSprite.Play("Digging");
							}
							else{
								ToolAnim.Play("Digging");
								animatedSprite.Play("DiggRun");
							}
							Digging = true;
							
							DigSoundEffect.Play(0);
							
							Node2D Dirt = (Node2D)DirtProjectile.Instance();
							GetParent().AddChild(Dirt);		
							Dirt.Position = Position+new Vector2(0,-20);
						}
						else{
							Digging = true;
							ToolAnim.Play("Digging");
							animatedSprite.Play("HitRock");
							inputsX = 0;
							Speed = 0;
							ToolInuse = true;
						}
					}
					else{
						Digging = true;
						ToolAnim.Play("Digging");
						animatedSprite.Play("HitRock");
						inputsX = 0;
						Speed = 0;
						ToolInuse = true;
					}
				}
				else{
					
					ToolInuse = true;
					
					Speed = 0;
					inputsX = 0;
					ShovelSwing.Set("ShootingLeft", facingLeft);

					if (currentAttack == 1){
						ToolAnim.Play("ShovelSwing");
						animatedSprite.Play("ShovelAttack1");
						Digging = true;
						currentAttack = 2;
					}
					else{
						ToolAnim.Play("ShovelSwing");
						animatedSprite.Play("ShovelAttack2");
						Digging = true;
						currentAttack = 1;
					}
				}
			}
			else{
				
						
				Digging = true;
				
				ShovelSwing.Set("ShootingLeft", facingLeft);
				
				if (currentAttack == 1){
					ToolAnim.Play("ShovelSwing");
					animatedSprite.Play("ShovelSwingAir1");
					currentAttack = 2;
				}
				else{
					ToolAnim.Play("ShovelSwing");
					animatedSprite.Play("ShovelSwingAir2");
					currentAttack = 1;
				}
			}	
			UseTimer = 0;
		}
		else{
			Digging = false;	
			ToolInuse = false;
		}	
	}

	private bool ShovelDashing= false;
	void ShovelDash(){
		if (Input.IsActionJustPressed("UseTool") && ! ShovelDashing){
			ShovelDashing = true;
			animatedSprite.Play("DashShovelSpin");
			DashTime = 1f;
			gravity = 0.3f;
			SpinParticalEffect.Emitting = true;
		}
	}

	//FixForwhenSwitchingAnimations	
	void NotPlayingDigAnim(){
		Digging = false;
		ToolInuse = false;
	}
	//BlowTorch -------------------------------------------------->
	private bool BlowStart = true;

	private float BlowTime = 1;

	void BlowTorch(float inputsX){
		if (IsOnFloor())
			BlowStart = true;
		
		else{
			if (Input.IsActionJustPressed("UseTool") && BlowStart){
				CharacterStates = 6;
				YSpeed = -10;	
			}
		}	
	}			
	void BlowTorchDown(float delta){
		
		if(BlowStart){
		
			animatedSprite.Play("BlowTourchDownStart");
			
			if (animatedSprite.Frame == 2){
				BlowStart = false;
				BlowTime = 1;
			}
		}
		else{
			BlowTime -= 1*delta	;
			YSpeed = -15;
			animatedSprite.Play("BlowTourchDown");
			if (BlowTime < 0)
				CharacterStates = 1;
		}		
		if (Input.IsActionJustPressed("UseTool"))
			CharacterStates = 1;
	}

	//Climbing ------------------------------------------------------------------->

	private bool turning = false;

	private bool ClimbingOnToladderFroAbove = false;

	private bool ExitingLadder = false;

	private bool LadderHasTop = false;

	float SetCustomOffsetHeight = 0;

	void Climbing(){
		
		switch (ClimbType){
			case 1:
				//Climbing vine
				
				if(Math.Round(ladderPoss.x-5*animatedSprite.Scale.x ) < Mathf.Round(Position.x)){
					Speed = -50;
					turning = true;
				}
				else if  (Mathf.Round(ladderPoss.x-5*animatedSprite.Scale.x ) >  Mathf.Round(Position.x)){
					Speed = 50;
					turning = true;
				}
				else{
					Speed = 0;
					turning = false;
				}
				MaxAirMovement = 100;
				
				SnapToGround = false;
		
				if (inputsX < 0 && !facingLeft){
					animatedSprite.Scale = new Vector2(1,1);
					animatedSprite.Play("Turning");
					facingLeft = true;
				}
				if (inputsX > 0 && facingLeft){
					animatedSprite.Scale = new Vector2(-1,1);
					animatedSprite.Play("Turning");
					facingLeft = false;
				}
				if (Input.IsActionJustPressed("jump")){
					CharacterStates = 1;
					YSpeed = -250;
					return;
				}
				var inputsY =  Input.GetActionStrength("Crouch") - Input.GetActionStrength("Move_Up");
				
				if (Position.y > ladderPoss.y + LadderExtence && inputsY > 0)
					inputsY = 0;
					
				if (turning)
					animatedSprite.Play("TurnAroundVine");
				
				else{
					if (inputsY == 0)
						animatedSprite.Play("ClimbingVineIdle");
					if (inputsY < 0)
						animatedSprite.Play("ClimbingUpVine");
					if (inputsY > 0)	
						animatedSprite.Play("ClimbDownVine");
					if (IsOnFloor() && inputsY > 0)
						CharacterStates = 1;
				}
				YSpeed = inputsY*150;

				break;
			

			case 2:
				//Climbing Ladder
				
				if (LadderHasTop){
					if (ClimbingOnToladderFroAbove){
						YSpeed = 150;
						SetCollisionMaskBit(9, false);
						fallingThroughGround = true;
					}
				}
				if  (Math.Round(ladderPoss.y-LadderExtence +32 ) <  Math.Round(Position.y))
					ClimbingOnToladderFroAbove = false;
					
					
				if (Math.Round(ladderPoss.x ) <  Math.Round(Position.x)){
					Speed = -50;
					turning = true;
				}
				else if (Math.Round(ladderPoss.x ) > Math.Round(Position.x)){
					Speed = 50;
					turning = true;
				}
				else{
					Speed = 0;
					turning = false;
				}
				
				if (Input.IsActionJustPressed("jump")){
					CharacterStates = 1;
					YSpeed = -250;
					SetCollisionMaskBit(9, true);
					fallingThroughGround = false;
					ExitingLadder = false;
					return;
				}
				SnapToGround = false;
				
				MaxAirMovement = 100;
				
				SetCollisionMaskBit(9, false);
				fallingThroughGround = true;
				if (LadderHasTop){
					if (ExitingLadder){
						animatedSprite.Play("ClimbingOffLadder");
						if (Math.Round(ladderPoss.y-LadderExtence+5) > Math.Round(Position.y)){
							YSpeed = 10;
							SetCollisionMaskBit(9, true);
							fallingThroughGround = false;
							if (IsOnFloor()){
								CharacterStates = 1;
								ExitingLadder = false;
								return;
							}
						}
						else
							YSpeed = -100;
					}
				}
				if (!ClimbingOnToladderFroAbove && !ExitingLadder){
					
					inputsY =  Input.GetActionStrength("Crouch") - Input.GetActionStrength("Move_Up");
						
					if (Position.y > ladderPoss.y + LadderExtence && inputsY > 0){
						inputsY = 0;
						Speed = 0;
						YSpeed = 0;
						CharacterStates = 1;
					}
					if (Position.y < ladderPoss.y-LadderExtence +32 - SetCustomOffsetHeight && inputsY < 0){
						
						inputsY = 0;
						
						if (LadderHasTop)
							ExitingLadder = true;
					}
					if (inputsY == 0)
						animatedSprite.Play("ClimbingLadder");
					if (inputsY < 0)
						animatedSprite.Play("ClimbingUpLadder");
					if (inputsY > 0)	
						animatedSprite.Play("ClimbingDownLadder");
					if (IsOnFloor() && inputsY > 0)
						CharacterStates = 1;
						
					YSpeed = inputsY*150;
				}
				break;
		}
	}

//EnterDoorbuilding------------------------------------------------------------------->
	private Vector2 newDoorPos;

	void Enteringdoor(Vector2 Newposition){
		animatedSprite.Play("EnterDoor");
		Speed = 0;
		wallJumpValocity = 0;
		if (animatedSprite.Frame == 4){
			Position = Newposition;
			CharacterStates = 1;
		}
	}

//Health -------------------------------------------------->

	 [Signal]
    public delegate void PlayerHit();
	
 	[Signal]
    public delegate void PlayerDead();

	public bool BeenHit = false;

	void HealthUpdated(int Damage){
		if (!enteringdoor){
			if (Anim.CurrentAnimation != "Hit"){
				EmitSignal("PlayerHit",Damage);
				Anim.Play("Hit");
				BeenHit = true;
			}
		}
	}
	void _on_Control_Dead(){
		CharacterStates = 7;
		EmitSignal("PlayerDead");
		animatedSprite.Play("Dead");
		wallJumpValocity = 0;
	}
	void Money(int Amount){
		GraphicsUI.Set("UpdateMoney",Amount);
	}
//Save Game -------------------------------------------------->

	void SaveGame(){
		
		GraphicsUI.Call("SetCheckpointandSaveGame",CameraAria,UpPos,leftPos);
	}
	
	

//RespawnPlayer -------------------------------------------------->
	void _on_Control_movePlayerBacktoSpawn(Vector2 Movement){
		Position = Movement;
		animatedSprite.Play("Idle"); 
	}
	

//PlayerUnPaused -------------------------------------------------->
	void _on_Control_CanPlay(){
		CharacterStates = 1;
	}



	[Signal]
    public delegate void ExitedDoor();

	private int ExitDirect = 0;

	private int aria = 1;
	private int section = 1;

	private int offset1 = 0;
	private int offset2 = 0;
	private int offset3 = 0;
	private int offset4 = 0;
	private int offset5 = 0;

//Enter New Aria
	void ExitDoor(){
		EmitSignal("ExitedDoor",Cam);
		Anim.Play("ExitDoor");
		
		Cam.Set("SetBackground",(aria,section,offset1,offset2,offset3,offset4,offset5));
		
		dashCollider.Disabled = true;
		
		switch (AbilityUse){
			// Standerd Movement
			case 0:
				CharacterStates = 1;

				break;
			case 1:
				CharacterStates = 8;

				break;
			case 2:
				CharacterStates = 11;

				break;
			case 3:
				CharacterStates = 12;
				if (ExitDirect == 4)
					Position += new Vector2(0,32);
				if (ExitDirect == 1)
					Position -= new Vector2(0,32);

				break;
		}
		AbilityUse = 0;
		
			
		if(DashPower != null){
				DashPower.QueueFree();
				DashPower = null;
		}
		animatedSprite.Modulate = Colors.White;
		if(ExitDirect == 1)
			YSpeed = -300;
	}		

//Enter New Aria Compleate
	void  ExitCompleate(){
		enteringdoor = false;
	}
		

	private int AbilityUse = 0;

	private Vector2 CameraAria;

	private int leftPos;


	private int  UpPos;

	private bool enteringdoor = false;
	
	void _on_CamAria_EnterDoor(int Direction,Vector2 AriaPos,int leftmost,int upmost){
		
		enteringdoor = true;
		
		CameraAria = AriaPos;
		leftPos = leftmost;
		UpPos = upmost;
		gravity = Stabilgravity;
		ShovelDashing = false;
		SpinParticalEffect.Emitting = false;
		if(CharacterStates == 8)
			AbilityUse = 1;
			
			
		if (CharacterStates == 11)
			AbilityUse = 2;
			
		if (CharacterStates == 12)
			AbilityUse = 3;
		Anim.Play("EnterDoor");
		
		ExitDirect = Direction;
		
		CharacterStates = 7;
		
	}
//Unlocked New Item ---------------------------------------->
	[Signal]
    public delegate void GotItem();
	void gotItem(int ItemID,bool SpawnEnime,object EnimeNode){
		EmitSignal("GotItem",ItemID,SpawnEnime,EnimeNode);		
		
	}

//Holding Item
	void HoldNotPerformingAnyAction(float inputsX,float delta){
			HoldHorizontal_Movement(inputsX,delta);
			HoldVerticalMovement(delta,600);
	}
	
	//Set Horizontal Movement
	void HoldHorizontal_Movement(float inputsX ,float delta){
		

		//fallThroughPlatforms
		if (fallingThroughGround){
			if (Input.IsActionJustReleased("Crouch")){
				SetCollisionMaskBit(9, true);
				
				fallingThroughGround = false;
			}
		}
		//set ground movement
		if (IsOnFloor()){
			
		

			//fallThroughPlatforms
			if (Input.IsActionJustPressed("Crouch")){
				SetCollisionMaskBit(9, false);
				fallingThroughGround = true;
			}
			
			 
			
			//handleCrouching
			if (!Input.IsActionPressed("Crouch")){
			
				SetCollisionMaskBit(9, true);
				fallingThroughGround = false;
			}

			
			//SetDirectionFacing
			if (CharacterStates != 4 && !Digging){
				if (inputsX > 0 && !facingLeft){
					animatedSprite.Scale = new Vector2(1,1);
					animatedSprite.Play("TurnHolding");
					TurnCompleat = false;
					facingLeft = true;
					MaxAirMovement = 70;
				}
				if (inputsX < 0 && facingLeft){
					animatedSprite.Scale = new Vector2(-1,1);
					animatedSprite.Play("TurnHolding");
					TurnCompleat = false;
					facingLeft = false;
					MaxAirMovement = 70;
				}
			}
			//SetMovingSpeed
			Speed += 900 * (inputsX)* delta;
			Speed *= (float)Math.Pow(1.0f - MoveDamping, delta*10);
			
			//WallJumpSpeed
			wallJumpValocity = 0;
			
			if (ChargeBoosted){
				animatedSprite.Modulate = Colors.White;
				ChargeBoosted = false;
			}
		}
		//set Air movement horizontal
		else{
			wallJumpValocity =  Mathf.Lerp(wallJumpValocity, 0, 0.1f);
				
			
			Speed += 900 * (inputsX) *delta;
			Speed *= (float)Math.Pow(1.0f - AirMoveDamping, delta*10);
			Speed = Math.Max(Speed,-Math.Abs(MaxAirMovement));
			Speed = Math.Min(Speed,Math.Abs(MaxAirMovement));
			
			
		}

		if (Math.Abs(inputsX) < 0.1 && Math.Abs(Speed) < 30){
			Speed = 0;
		}
		if(IsOnWall()){
			
			SnapToGround = false;
			MaxAirMovement = 90;
		}
	}
	//Vertical Movement
	void HoldVerticalMovement(float delta,float MaxfallSpeed){
		
		//Handle Gravity
		if(!IsOnFloor()){
			YSpeed += gravity * delta;
			YSpeed = Mathf.Clamp(YSpeed,-10000,MaxfallSpeed);
			JumpCheckTime -= 1 * delta;
			if (Input.IsActionJustPressed("jump")){
				JumpCheckTime = 0.2f;
			}
		}
		else{
			SnapToGround = true;
			YSpeed = 5;
		}  
	
		//bumpHeadOnceling	
		if (IsOnCeiling() && YSpeed < 0 ){
			YSpeed = 0;
		}
		//Small jump
		if (Input.IsActionJustPressed("jump") && velocity.y < -50 && !Dashing && gravity > 0){
			YSpeed = -50;
		}
		
		//CheckIfCanJump
		if ((Input.IsActionJustPressed("jump") || JumpCheckTime > 0)&& IsOnFloor() &&  !Input.IsActionJustPressed("Dash")){
			SnapToGround = false;
			YSpeed = -JumpPower;
			JumpCheckTime = 0;
		
			if (Math.Abs(Speed)> MaxAirMovementFromStandStill)  
				MaxAirMovement = Math.Abs(Speed);
			else 
				MaxAirMovement = MaxAirMovementFromStandStill;
		}

	   
	}
	void HoldHanldeAnimations(){
		

		if(!IsOnFloor()){

			if(animatedSprite.Animation == ("ShovelSpinn")){
				
				aboutToTouchGround = CheckForGround();

				if(aboutToTouchGround){
					YSpeed = -JumpPower*0.5f;
					SnapToGround = false;
					JumpCheckTime = 0;
					if(Speed < 200){
						Speed += 50;
					}
				}

			}

			
			if(!Digging){
			
				
				if(YSpeed > -1 && gravity > 0){
					animatedSprite.Play("Falling");

					aboutToTouchGround = CheckForGround();
						

					if(aboutToTouchGround && !LandSoundEffect.Playing){
						LandSoundEffect.Play();
						aboutToTouchGround = false;
					}
				}
				else
					animatedSprite.Play("Jump");
				
			}
		}
		
		if(IsOnFloor()){
			
			//if(animatedSprite.Animation == ("ShovelSpinn")){
			//	YSpeed = -100;
			//	animatedSprite.Play("SpinnJump");
			//	Spinnging = true;
			//	Digging = false;
			//}

			if(!Digging){
				if(!TurnCompleat && animatedSprite.Frame == 2){
					TurnCompleat = true;
				}
				if(TurnCompleat || animatedSprite.Animation == "Falling"){
					Spinnging = false;
			
					if(Math.Abs(Speed) < 0.1 || IsOnWall()){
						animatedSprite.Play("IdleHolding");
					
					}
					else{
						animatedSprite.Play("RunHolding");
						
						
					}
				}
			}
		}

		if (animatedSprite.Animation == "RunHolding"){
			DashParticals.Emitting = true;
			if (facingLeft){
				DashParticals.Direction = new Vector2(-0.3f,-0.935f);
			}else{
				DashParticals.Direction = new Vector2(0.3f,-0.935f);
			}
		}else{
				DashParticals.Emitting = false;
		}

	}


//ZipWireing -------------------------------------------------->			
	void ZipWireing(float ZipSpeed,float posintion,bool directionTraveling){
		
		
		animatedSprite.Play("Zipwireing");
		
		Speed = 0;
		
		YSpeed = 0;
		
		wallJumpValocity = 0;
		
		if (directionTraveling && !facingLeft){
			animatedSprite.Scale = new Vector2(1,1);
			facingLeft = true;
		}
		
		if (!directionTraveling && facingLeft){
			animatedSprite.Scale = new Vector2(-1,1);
			facingLeft = false;
		}
		if(DashPower != null){
			DashPower.QueueFree();
			DashPower = null;
		}
		if (Input.IsActionJustPressed("jump")){
		
			YSpeed = -JumpPower;
			
			MaxAirMovement = Math.Abs(ZipSpeed * 130) ;
			CharacterStates = 1;
			
			if (facingLeft){
				Speed = 150 * (ZipSpeed);
				wallJumpValocity = 350 * (ZipSpeed+0.3f);
			}
			else{
				Speed = -150 * (ZipSpeed);
				wallJumpValocity = -350 * (ZipSpeed+0.3f);
			}
			velocity.x = Math.Max(velocity.x,-MaxAirMovement);
			velocity.x = Math.Min(velocity.x,MaxAirMovement);
		}
		if (IsOnFloor() || IsOnWall()){
			CharacterStates = 1;
		}
			
		if (posintion == 1){
		
			YSpeed = -JumpPower*0.5f;
			
			MaxAirMovement = Mathf.Abs(ZipSpeed * 130);
			
			if (facingLeft){
				Speed = 130 * (ZipSpeed );
				wallJumpValocity = 350 * (ZipSpeed+0.3f);
			}
			else{
				Speed = -130 * (ZipSpeed);
				wallJumpValocity = -350 * (ZipSpeed+0.3f);	
			}
			
			velocity.x = Math.Max(velocity.x,-MaxAirMovement);
			velocity.x = Math.Min(velocity.x,MaxAirMovement);
			
			CharacterStates = 1;
		}
	}
}
