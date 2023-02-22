extends Node

##### TODO: This script is now obsolete. Delete this script!

var parent

var buffer: bool = false

signal check(_accidental)

signal accidental_positions_updated



func _on_Accidental_position_changed(_accidental: Sprite) -> void:
	emit_signal("check", _accidental)
	if not buffer:
		buffer = true
#		var ng_idx: int = yield(parent, "placed_notes")
#		print("accidental_process, got past yield, ng_idx: ", ng_idx)
#	pass

func _ready():
	pass



