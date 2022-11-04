extends Panel


var page = 0

var Line1 = []

var Line1Text = ""
var some_string = "Name£One|Two|Three|Four"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var some_array = some_string.split("|", true)
	
	print(some_array.size()) # Prints 2
	print(some_array[0]) # Prints "One"
	print(some_array[1]) # Prints "Two,Three,Four"
	
	Line1 = some_array[0].split(0, true)
	
	$RichTextLabel.set_bbcode(some_array[0])
	
	$RichTextLabel.visible_characters = 0
	

