extends Node2D

onready var mouse_label: Label = get_node("MouseLabel")

var parent: TextureRect
var default_ng_x_position_color: Color = Color.orangered
var ng_x_position_color: Color = Color.blue
var resulting_ng_x_position_color: Color = Color.hotpink
var line_thickness: float = 1.5
var ng_label_y_pos: float = 20.0

func draw_default_note_group_x_positions() -> void:
	var z: Vector2 = parent.rect_size
	for i in range(parent.TWENTY_FOUR_INT):
		var note_group: NoteGroup = parent.note_groups[i]
		var x: float = note_group.DEFAULT_X_POSITION\
			+ float(i % parent.TWELVE_INT) * parent.note_group_spacing
		var a: Vector2 = Vector2(x, 0)
		var b: Vector2 = Vector2(x, z.y)
		draw_line(a,b, default_ng_x_position_color, line_thickness)
		
func draw_note_group_x_positions() -> void:
	var z: Vector2 = parent.rect_size
	for i in range(parent.TWENTY_FOUR_INT):
		var note_group: NoteGroup = parent.note_groups[i]
		var x: float = note_group.x_position
		var a: Vector2 = Vector2(x, 0)
		var b: Vector2 = Vector2(x, z.y)
		draw_line(a,b, ng_x_position_color, line_thickness)

func draw_resulting_note_group_x_positions() -> void:
	if parent.ng_resulting_x_positions.keys().empty():
		return
	var z: Vector2 = parent.rect_size
	for i in range(parent.TWELVE_INT):
		var note_group: NoteGroup = parent.note_groups[i]
		var x: float = parent.ng_resulting_x_positions[i]
		update_ng_label_position(i, Vector2(x, ng_label_y_pos))
		if x == note_group.DEFAULT_X_POSITION\
			+ float(i % parent.TWELVE_INT) * parent.note_group_spacing: # If same as default.
			continue
		var a: Vector2 = Vector2(x, 0)
		var b: Vector2 = Vector2(x, z.y)
		draw_line(a,b, resulting_ng_x_position_color, line_thickness)
	
func _input(event):
	if event is InputEventMouseMotion:
		var p: Vector2 = get_local_mouse_position()
		mouse_label.text = "local mouse: "+str(p)

func update_ng_label_position(_idx: int, _pos: Vector2) -> void:
	var lab: Label = get_node("NG"+str(_idx)+"Label")
	lab.rect_position = _pos

func draw_clef_margin() -> void:
	var x: float = parent.CLEF_MARGIN
	var z: Vector2 = parent.rect_size
	var a: Vector2 = Vector2(x, 0)
	var b: Vector2 = Vector2(x, z.y)
	draw_line(a,b, Color.slateblue, line_thickness)
	
func _draw():
	if parent == null:
		return
	draw_clef_margin()
	draw_default_note_group_x_positions()
	draw_note_group_x_positions()
	draw_resulting_note_group_x_positions()


func update_ng_label_texts() -> void:
	if parent == null:
		return
	for i in range(parent.TWELVE_INT):
		var lab: Label = get_node("NG"+str(i)+"Label")
		lab.text = str(i)

func _ready():
	
	pass
