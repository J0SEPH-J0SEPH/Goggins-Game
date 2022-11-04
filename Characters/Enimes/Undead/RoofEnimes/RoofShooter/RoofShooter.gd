extends Node2D




const Shot = preload("res://Characters/Enimes/Undead/RoofEnimes/RoofShooter/Projectile.tscn")

func Shoot():
	var CurrentShot = Shot.instance()
	CurrentShot.position = position + Vector2(0,0)
	get_parent().add_child(CurrentShot)
 


func _on_VisibilityNotifier2D_screen_entered():
	$AnimationPlayer.play("Shooter")


func _on_VisibilityNotifier2D_screen_exited():
	$AnimationPlayer.stop(true)
	print("stopShooting")
