extends Node

var saveGame

var music
var bossinfo

export var MusicTostopplaying = 1
	
func _on_VisibilityNotifier2D_screen_entered():
	
	if music == null:
		bossinfo = get_parent()
		music = bossinfo.TopNode.Player.Music
	
	if !bossinfo.isbossDead:
		music.StopPlaying(MusicTostopplaying)
