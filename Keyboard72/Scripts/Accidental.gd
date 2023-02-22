extends Sprite

onready var area_2d: Area2D = get_node("Area2D")
onready var collision_shape_2d: CollisionShape2D = get_node("Area2D/CollisionShape2D")

const DEFAULT_ACCIDENTAL_OFFSET: Vector2 = Vector2(-25, -54)
const ACCIDENTAL_STRINGS: Array = ["flat", "flat_up_1", "flat_up_2", "flat_up_3", "flat_down_1", "flat_down_2", "flat_down_3",\
	"natural", "natural_up_1", "natural_up_2", "natural_up_3", "natural_down_1", "natural_down_2", "natural_down_3",
	"sharp", "sharp_up_1", "sharp_up_2", "sharp_up_3", "sharp_down_1", "sharp_down_2", "sharp_down_3"]
const PX_BETWEEN_X: float = 2.73
#const PX_BETWEEN_Y: float = 1.26
const OFFSETS: Dictionary = {
	"flat": Vector2(0, 25),
	"flat_up_1": Vector2(0, 25),
	"flat_up_2": Vector2(0, 25),
	"flat_up_3": Vector2(0, 25),
	"flat_down_1": Vector2(0, 44),
	"flat_down_2": Vector2(0, 55),
	"flat_down_3": Vector2(0, 64),
	
	"natural": Vector2(-3, 40),
	"natural_up_1": Vector2(-3, 40),
	"natural_up_2": Vector2(-3, 40),
	"natural_up_3": Vector2(-3, 40),
	"natural_down_1": Vector2(1, 53),
	"natural_down_2": Vector2(1, 59),
	"natural_down_3": Vector2(1, 70),
	
	"sharp": Vector2(-2, 41),
	"sharp_up_1": Vector2(-2, 41),
	"sharp_up_2": Vector2(-2, 41),
	"sharp_up_3": Vector2(-2, 41),
	"sharp_down_1": Vector2(-2, 51),
	"sharp_down_2": Vector2(-2, 61),
	"sharp_down_3": Vector2(-2, 73),
}
const SIZES: Dictionary = {
	"flat":  Vector2(21, 50),
	"flat_up_1": Vector2(24, 60),
	"flat_up_2": Vector2(24, 69),
	"flat_up_3": Vector2(24, 79),
	"flat_down_1": Vector2(25, 70),
	"flat_down_2": Vector2(25, 81),
	"flat_down_3": Vector2(25, 90),
	
	"natural":  Vector2(16, 58),
	"natural_up_1": Vector2(20, 68),
	"natural_up_2": Vector2(20, 75),
	"natural_up_3": Vector2(20, 86),
	"natural_down_1": Vector2(20, 70),
	"natural_down_2": Vector2(20, 76),
	"natural_down_3": Vector2(20, 87),
	
	"sharp":  Vector2(22, 58),
	"sharp_up_1": Vector2(22, 66),
	"sharp_up_2": Vector2(22, 78),
	"sharp_up_3": Vector2(22, 90),
	"sharp_down_1": Vector2(22, 68),
	"sharp_down_2": Vector2(22, 78),
	"sharp_down_3": Vector2(22, 90),
}
var area_padding: Vector2 = Vector2(2,4) setget set_area_padding 
# area_padding is extra pixels added to extents of the area2d's collision shape.
var index: int = -1 # The index of the Pitch associated with this Accidental in
# GrandStaff's active_pitches array.
var accidental: String = "flat" setget set_accidental
var pos_priority: int setget set_pos_priority # Lower means further right against notehead.
var clashing_with: Array # Indices of other Accidentals this Accidental is clashing with.


signal position_changed(_accidental)
signal area_clash(_accidental, _other_accidental)
signal area_exit(_accidental, _other_accidental)
signal clashing_updated(_accidental)

func set_accidental(_accidental: String) -> void:
	
	accidental = _accidental
	frame = ACCIDENTAL_STRINGS.find(accidental)
	area_2d.position = -DEFAULT_ACCIDENTAL_OFFSET - SIZES[accidental] + (SIZES[accidental] * 0.5) + OFFSETS[accidental]
	collision_shape_2d.shape.extents = (SIZES[accidental] * 0.5) + area_padding
#	update_tl_and_br()

func make_collision_shape_unique() -> void:
	var ext: Vector2 = collision_shape_2d.shape.extents
	var rect_shape: RectangleShape2D = RectangleShape2D.new()
	rect_shape.extents = ext
	collision_shape_2d.shape = rect_shape
	
func set_area_padding(_area_padding: Vector2) -> void:
	area_padding = _area_padding
	area_2d.position = -DEFAULT_ACCIDENTAL_OFFSET - SIZES[accidental] + (SIZES[accidental] * 0.5) + OFFSETS[accidental]
	collision_shape_2d.shape.extents = (SIZES[accidental] * 0.5) + area_padding
#	update_tl_and_br()

func get_tl() -> Vector2: # Get the topleft corner of area_2d relative to grand staff.
	var g: Vector2 = area_2d.position - collision_shape_2d.shape.extents
	return position + g
	
func get_br() -> Vector2: # Get the bottomright corner of area_2d relative to grand staff.
	var g: Vector2 = area_2d.position + collision_shape_2d.shape.extents
	return position + g


func set_pos_priority(_pos_priority: int) -> void:
	pos_priority = _pos_priority

func _ready():
	make_collision_shape_unique()

func set_position_x(_x: float) -> void:
	position.x = _x
	emit_signal("position_changed", self)


func _on_Area2D_area_entered(area: Area2D) -> void:
	# This accidental is colliding with another accidental.
	# Whoever has lowest pos_priority stays, and the other must move to the left.
	var their_acc: Sprite = area.get_parent()
	if their_acc.visible && visible: # If both of us are visible.
		clashing_with.append(their_acc.index)
		#emit_signal("area_clash", self, their_acc)
#		print("Accidental_"+str(index), " entered area of Accidental_", their_acc.index)
		emit_signal("clashing_updated", self)


func _on_Area2D_area_exited(area: Area2D) -> void:
	var their_acc: Sprite = area.get_parent()
	if their_acc.visible && visible: # If both of us are visible.
		clashing_with.remove(clashing_with.find(their_acc.index))
		#emit_signal("area_exit", self, their_acc)
#		print("Accidental_"+str(index), " EXITED area of Accidental_", their_acc.index)
		emit_signal("clashing_updated", self)
