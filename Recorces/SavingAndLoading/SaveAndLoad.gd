extends Node

var path = ""
var path2 = ""
var path3 = ""

export var SaveExists = false

var default_data = {
	
	"GameStarted": false,
	
	"Difficulty": 1,
	
	"player":{
		"maxhealth" : 10,
		"health" : 10,
		"Xpos" : -2464,
		"Ypos" : -154,
		"Money":0
		},
	"PlayerEquips":{
		"HasShovel": false,
		"HasDash":false
	},
	"BossesBeat":{
		"WallEye":false,
		"FootBaller":false,
		"StickIncect":false
		},
	"camera":{
		"UpPos" : 120,
		"PositionX" : -2372,
		"PositionY" : -160,
		"Left" : 240,
	}
		
	
	
}

var data = { }
var data2 = { }
var data3 = { }

func _ready():
	
	path = ProjectSettings.globalize_path("user://") + "data.json"
	path2 = ProjectSettings.globalize_path("user://") + "data2.json"
	path3 = ProjectSettings.globalize_path("user://") + "data3.json"
	

func SetSaveFiles():
	
	SetFile1()
	SetFile2()
	SetFile3()
	
	get_parent()._SetSaveFiles()
		
func SetFile1():
	var file = File.new()
	
	
	if not file.file_exists(path):
		reset_data(1)
		return	
		
	file.open(path, file.READ)
	
	var text = file.get_as_text()
			
	data = parse_json(text)
	
	
	
	file.close()
	
func SetFile2():
	var file = File.new()
	if not file.file_exists(path2):
		reset_data(2)
		return	
	
	file.open(path2, file.READ)
	
	var text = file.get_as_text()
			
	data2 = parse_json(text)
	
	
	file.close()

func SetFile3():
	var file = File.new()
	if not file.file_exists(path3):
		reset_data(3)
		return	
		
	file.open(path3, file.READ)
	
	var text = file.get_as_text()
			
	data3 = parse_json(text)
	
	file.close()
	
func load_game(curFile : int):
	
	
	match curFile:
		1:
			SetFile1()
		2:
			SetFile2()
		3:
			SetFile3()
	
	
	
	
func save_game(curFile : int):
	var file
	
	file = File.new()
	
	
	match curFile:
		1:
			file.open(path, File.WRITE)
			file.store_line(to_json(data))
		2:
			file.open(path2, File.WRITE)
			file.store_line(to_json(data2))
		3:
			file.open(path3, File.WRITE)
			file.store_line(to_json(data3))
	
	file.close()

func reset_data(curFile : int):
	match curFile:
		1:
			data = default_data.duplicate(true)
		2:
			data2 = default_data.duplicate(true)
		3:
			data3 = default_data.duplicate(true)
