extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var LastSongPlayer = 1
# Called when the node enters the scene tree for the first time.
func StopPlaying(MusicID: int):
	match MusicID:
		1:
			$Forest.playing = false
		2:
			$Boss1.playing = false

func StartPlaying(MusicID: int):
	match MusicID:
		1:
			$Forest.playing = true
			LastSongPlayer = 1
		2:
			$Boss1.playing = true
			LastSongPlayer = 2
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
