extends Camera2D






var previuseCameraPosition = get_camera_position()

var CameraShake = false

var shake_amount = 1

var ShakeTime = 0

func _process(delta):
	
	previuseCameraPosition = get_camera_position()

	if CameraShake:
		if ShakeTime <= 0:
			if shake_amount < 0:
				shake_amount = 0;
			else:
				shake_amount -= 1*delta;
				
		set_offset(Vector2(
		rand_range(-1.0, 1.0) * shake_amount,
		rand_range(-1.0, 1.0) * shake_amount 
		))
		ShakeTime -= 1*delta
		if shake_amount <= 0:
			CameraShake = false
			set_offset(Vector2(0,0))

func ShakeCamera(shakeamount : float, Shaketime : float):
	shake_amount = shakeamount
	ShakeTime = Shaketime
	CameraShake = true





onready var CurrentBack1 = $ParallaxBackground/ParallaxLayer/Forest1
onready var	CurrentBack2 = $ParallaxBackground/ParallaxLayer2/Forest1
onready var	CurrentBack3 = $ParallaxBackground/ParallaxLayer3/Forest1
onready var	CurrentBack4 = $ParallaxBackground/ParallaxLayer4/Forest1
onready var	CurrentBack5 = $ParallaxBackground/ParallaxLayer5/Forest1

var Offset1 = -300
var Offset2 = -344
var Offset3 = 200
var Offset4 = 100
var Offset5 = -40

func SetBackground(Aria : int, Section : int, Offset1 : int, Offset2 : int, Offset3 : int, Offset4 : int, Offset5 : int):
	
	CurrentBack1.visible = false
	CurrentBack2.visible = false
	CurrentBack3.visible = false
	CurrentBack4.visible = false
	CurrentBack5.visible = false
	$ParallaxBackground/ParallaxLayer.motion_offset.y = Offset1
	$ParallaxBackground/ParallaxLayer2.motion_offset.y = Offset2
	$ParallaxBackground/ParallaxLayer3.motion_offset.y = Offset3
	$ParallaxBackground/ParallaxLayer4.motion_offset.y = Offset4
	$ParallaxBackground/ParallaxLayer5.motion_offset.y = Offset5
					
	match Aria:
		1:
			match Section:
				1:
					$ParallaxBackground/ParallaxLayer/Forest1.visible = true	
					$ParallaxBackground/ParallaxLayer2/Forest1.visible = true
					$ParallaxBackground/ParallaxLayer3/Forest1.visible = true
					$ParallaxBackground/ParallaxLayer4/Forest1.visible = true
					$ParallaxBackground/ParallaxLayer5/Forest1.visible = true			
					CurrentBack1 = $ParallaxBackground/ParallaxLayer/Forest1
					CurrentBack2 = $ParallaxBackground/ParallaxLayer2/Forest1
					CurrentBack3 = $ParallaxBackground/ParallaxLayer3/Forest1
					CurrentBack4 = $ParallaxBackground/ParallaxLayer4/Forest1
					CurrentBack5 = $ParallaxBackground/ParallaxLayer5/Forest1
					
				2:
					$ParallaxBackground/ParallaxLayer/Caves1.visible = true
					$ParallaxBackground/ParallaxLayer2/Caves1.visible = true			
					CurrentBack1 = $ParallaxBackground/ParallaxLayer/Caves1
					CurrentBack2 = $ParallaxBackground/ParallaxLayer2/Caves1
#func _on_Goggins_groundedUpdate(isGrounded):
	#drag_margin_v_enabled = !isGrounded
	
func EnableFading():
	$CanvasLayer/Panel.visible = true
