extends Node2D


var miniMap

func _on_Control_ConnectMiniMap(MiniMap: Node):
	miniMap = MiniMap
	
func SetTile(Xpos: int,Ypos: int):
	miniMap.SetTile(Xpos,Ypos)
