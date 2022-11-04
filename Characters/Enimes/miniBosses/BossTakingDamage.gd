extends Node


export var AreaWeakness = "Projectile"


export var AriaDamageDelt = 2

export var BodyWeakness = "Dirt"


export var BodyDamageDelt = 2

func _on_Hitpoint_body_entered(body):
	if body.is_in_group(BodyWeakness):
		get_parent().TakenDamage(BodyDamageDelt,body,BodyWeakness)



func _on_Hitpoint_area_entered(area):
	
	if area.is_in_group(AreaWeakness):
		get_parent().TakenDamage(AriaDamageDelt,area,AreaWeakness)
